#!/bin/zsh

# Rebase stacked worktree branches onto main and push to GitHub.
#
# Each project lives in its own folder under ~/Development/config:
#   $HOME/Development/config/<project>/<project>-repo        main repo
#   $HOME/Development/config/<project>/wktrees/<worktree>    linked worktrees
# Worktrees are matched by the branch they have checked out, not by folder
# name. Every project has the same stacks (bottom-up), one worktree per branch:
#   main -> km -> tk
#   main -> chaco -> sawtooth
#
# Everything runs sequentially. Output matches repos-reset-to-origin.sh: a
# "--- project ---" header per project, then indented status lines.
# In each project, local main is first fast-forwarded from origin if behind,
# then pushed (never forced) so the rebased branches aren't published on top of
# commits GitHub doesn't have. Pushes are skipped when origin already has the
# commit, so a run with no changes only makes one fetch per project.
# Exit status is non-zero if any stack failed or was skipped.

export PATH=/opt/local/bin:/opt/local/sbin:$PATH

CONFIG_DIR="$HOME/Development/config"
PROJECTS=(dev-env dotfiles mac-config)
STACKS=("km tk" "chaco sawtooth")

# Print git's captured output indented under the current status line.
function show_output() {
  print -r -- "$1" | sed 's/^/    /'
}

# Rebase and push the worktrees of one stack, bottom-up.
# The first branch is rebased onto main; each branch above it is rebased with
# --onto so only its own commits are replayed on the rebased branch below.
# Stops at the first failure so branches above never sit on a stale base.
# Git's output is shown only when something fails.
function rebase_stack() {
  local wt br base fork lower_br old_tip new_tip remote_tip out
  local old_base="" new_base=""
  local -a cmd

  for wt in "$@"; do
    br=$(git -C "$wt" branch --show-current)
    old_tip=$(git -C "$wt" rev-parse HEAD) || return 1

    if [[ -z $old_base ]]; then
      base=main
      cmd=(rebase main)
    else
      base=$new_base
      # Where this branch actually forked from the branch below, per that
      # branch's reflog. Handles a lower branch that was amended or rewritten
      # since this one was last rebased. If the reflog has no answer, fall back
      # to the lower branch's tip from before this run, but only if this branch
      # really contains it; otherwise stop rather than replay the wrong commits.
      if ! fork=$(git -C "$wt" merge-base --fork-point "$lower_br" HEAD); then
        fork=$old_base
        if ! git -C "$wt" merge-base --is-ancestor "$fork" HEAD; then
          echo "  Error: can't determine where $br forked from $lower_br (reflog expired?). Rebase manually."
          return 1
        fi
      fi
      cmd=(rebase --onto "$new_base" "$fork")
    fi

    # Only rebase if the base isn't already part of this branch's history.
    if ! git -C "$wt" merge-base --is-ancestor "$base" HEAD; then
      out=$(git -C "$wt" "${cmd[@]}" 2>&1) || {
        echo "  Error: rebase of $br failed."
        show_output "$out"
        return 1
      }
    fi
    new_tip=$(git -C "$wt" rev-parse HEAD) || return 1

    # origin/$br was refreshed by the fetch in sync_main, so a match means the
    # remote already has this commit and no push is needed.
    remote_tip=$(git -C "$wt" rev-parse -q --verify "origin/$br")
    if [[ $new_tip == $remote_tip ]]; then
      echo "  Already up to date ($br @ ${new_tip[1,7]})."
    else
      out=$(git -C "$wt" push --force-with-lease origin "$br:$br" 2>&1) || {
        echo "  Error: push of $br failed."
        show_output "$out"
        return 1
      }
      if [[ $new_tip != $old_tip ]]; then
        echo "  Rebased and pushed ($br @ ${old_tip[1,7]} -> ${new_tip[1,7]})."
      else
        echo "  Pushed ($br @ ${new_tip[1,7]})."
      fi
    fi

    old_base=$old_tip
    new_base=$new_tip
    lower_br=$br
  done
}

# Fetch origin and fast-forward local main if it is behind. Local commits ahead
# of origin are left alone for the push step. Fails if main has diverged.
# Takes the project's main repo; the fast-forward is done in the checkout that
# has main checked out (if any) so its working tree stays in sync.
function sync_main() {
  local repo=$1 main_wt out old_main new_main

  # Fetch every branch (one round trip) so origin/main and the origin/* refs of
  # the stack branches are fresh; later steps skip pushes by comparing to them.
  out=$(git -C "$repo" fetch origin 2>&1) || {
    echo "  Error: failed to fetch from origin."
    show_output "$out"
    return 1
  }

  # Equal to or ahead of origin/main: nothing to fast-forward.
  git -C "$repo" merge-base --is-ancestor origin/main main && return 0

  if ! git -C "$repo" merge-base --is-ancestor main origin/main; then
    echo "  Error: main has diverged from origin/main."
    return 1
  fi

  old_main=$(git -C "$repo" rev-parse main)
  main_wt=$(git -C "$repo" worktree list --porcelain \
    | awk '/^worktree /{p=substr($0,10)} /^branch refs\/heads\/main$/{print p; exit}')

  if [[ -n $main_wt ]]; then
    out=$(git -C "$main_wt" merge --ff-only origin/main 2>&1)
  else
    out=$(git -C "$repo" branch -f main origin/main 2>&1)
  fi || {
    echo "  Error: failed to fast-forward main."
    show_output "$out"
    return 1
  }
  new_main=$(git -C "$repo" rev-parse main)
  echo "  Fast-forwarded main (${old_main[1,7]} -> ${new_main[1,7]})."
}

# Process one project: sync and push main, then rebase and push its stacks.
# Returns non-zero if anything failed or was skipped.
function process_project() {
  local project=$1
  local repo="$CONFIG_DIR/$project/$project-repo"
  local wt_dir="$CONFIG_DIR/$project/wktrees"
  local rc=0 wt b out stack br main_hash
  local -a branches paths

  printf -- "--- %s ---\n" $project

  if [[ ! -d "$repo/.git" ]]; then
    echo "  Error: main repo not found: $repo"
    return 1
  fi

  if [[ ! -d "$wt_dir" ]]; then
    echo "  Error: worktree folder not found: $wt_dir"
    return 1
  fi

  # Map branch name -> worktree path. Assumes every folder here is a linked
  # worktree (no clones); non-git entries are ignored. Git allows a branch in
  # only one worktree, so each stack branch maps to at most one path.
  by_branch=()
  for wt in "$wt_dir"/*(N/); do
    b=$(git -C "$wt" branch --show-current 2> /dev/null)
    [[ -n $b ]] || continue
    by_branch[$b]=$wt
  done

  # Bring local main up to date with origin, then push any local main commits
  # so the rebased branches aren't published on top of commits GitHub doesn't
  # have. Plain push, never forced. If either step fails, skip this project's
  # stacks.
  sync_main "$repo" || {
    echo "  Skipped: main sync failed."
    return 1
  }
  main_hash=$(git -C "$repo" rev-parse main)
  if [[ $main_hash == $(git -C "$repo" rev-parse -q --verify origin/main) ]]; then
    echo "  Already up to date (main @ ${main_hash[1,7]})."
  else
    out=$(git -C "$repo" push origin main 2>&1) || {
      echo "  Error: push of main failed."
      show_output "$out"
      echo "  Skipped: main push failed."
      return 1
    }
    echo "  Pushed (main @ ${main_hash[1,7]})."
  fi

  for stack in "${STACKS[@]}"; do
    branches=(${=stack})
    paths=()
    for br in $branches; do
      [[ -n ${by_branch[$br]} ]] && paths+=("${by_branch[$br]}")
    done

    if ((${#paths} != ${#branches})); then
      echo "  Skipped: stack '$stack' is missing a worktree."
      rc=1
      continue
    fi

    rebase_stack "${paths[@]}" || rc=1
  done

  return $rc
}

# --- Execution ---
if [[ ! -d "$CONFIG_DIR" ]]; then
  echo "Config directory not found: $CONFIG_DIR"
  exit 1
fi

echo "Rebasing worktrees onto main and pushing to origin:"
echo

typeset -A by_branch
failed=0

for project in "${PROJECTS[@]}"; do
  process_project "$project" || failed=1
  echo
done

exit $failed
