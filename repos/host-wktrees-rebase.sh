#!/bin/zsh

# Rebase stacked worktree branches onto main and push to GitHub.
#
# Each worktree lives one level down inside its project folder:
#   $HOME/Development/wktrees/<project>/<worktree>
# Every project has the same stacks (bottom-up), one worktree per branch:
#   main -> km -> tk
#   main -> chaco -> sawtooth
#
# Everything runs sequentially and prints one status line per branch.
# In each project, local main is first fast-forwarded from origin if behind,
# then pushed (never forced) so the rebased branches aren't published on top of
# commits GitHub doesn't have. Pushes are skipped when origin already has the
# commit, so a run with no changes only makes one fetch per project.
# Exit status is non-zero if any stack failed or was skipped.

WORKTREES_DIR="$HOME/Development/wktrees"
PROJECTS=(dev-env dotfiles mac-config)
STACKS=("km tk" "chaco sawtooth")

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
          echo "  $br: can't determine its base on $lower_br (reflog expired?); rebase manually" >&2
          return 1
        fi
      fi
      cmd=(rebase --onto "$new_base" "$fork")
    fi

    # Only rebase if the base isn't already part of this branch's history.
    if ! git -C "$wt" merge-base --is-ancestor "$base" HEAD; then
      out=$(git -C "$wt" "${cmd[@]}" 2>&1) || {
        echo "  $br: rebase FAILED" >&2
        echo "$out" >&2
        return 1
      }
    fi
    new_tip=$(git -C "$wt" rev-parse HEAD) || return 1

    # origin/$br was refreshed by the fetch in sync_main, so a match means the
    # remote already has this commit and no push is needed.
    remote_tip=$(git -C "$wt" rev-parse -q --verify "origin/$br")
    if [[ $new_tip == $remote_tip ]]; then
      echo "  $br: up to date"
    else
      out=$(git -C "$wt" push --force-with-lease origin "$br:$br" 2>&1) || {
        echo "  $br: push FAILED" >&2
        echo "$out" >&2
        return 1
      }
      if [[ $new_tip != $old_tip ]]; then
        echo "  $br: rebased and pushed"
      else
        echo "  $br: pushed"
      fi
    fi

    old_base=$old_tip
    new_base=$new_tip
    lower_br=$br
  done
}

# Fetch origin and fast-forward local main if it is behind. Local commits ahead
# of origin are left alone for the push step. Fails if main has diverged.
# Takes any worktree of the repo; the fast-forward is done in the checkout that
# has main checked out (if any) so its working tree stays in sync.
function sync_main() {
  local any_wt=$1 main_wt out

  # Fetch every branch (one round trip) so origin/main and the origin/* refs of
  # the stack branches are fresh; later steps skip pushes by comparing to them.
  out=$(git -C "$any_wt" fetch origin 2>&1) || {
    echo "$out" >&2
    return 1
  }

  # Equal to or ahead of origin/main: nothing to fast-forward.
  git -C "$any_wt" merge-base --is-ancestor origin/main main && return 0

  if ! git -C "$any_wt" merge-base --is-ancestor main origin/main; then
    echo "  main has diverged from origin/main" >&2
    return 1
  fi

  main_wt=$(git -C "$any_wt" worktree list --porcelain \
    | awk '/^worktree /{p=substr($0,10)} /^branch refs\/heads\/main$/{print p; exit}')

  if [[ -n $main_wt ]]; then
    out=$(git -C "$main_wt" merge --ff-only origin/main 2>&1)
  else
    out=$(git -C "$any_wt" branch -f main origin/main 2>&1)
  fi || {
    echo "$out" >&2
    return 1
  }
  echo "  main: fast-forwarded"
}

if [[ ! -d "$WORKTREES_DIR" ]]; then
  echo "Worktrees directory not found: $WORKTREES_DIR" >&2
  exit 1
fi

typeset -A by_branch
failed=0

for project in "${PROJECTS[@]}"; do
  echo "== $project =="

  if [[ ! -d "$WORKTREES_DIR/$project" ]]; then
    echo "  folder not found: $WORKTREES_DIR/$project" >&2
    failed=1
    continue
  fi

  # Map branch name -> worktree path. Assumes every folder here is a linked
  # worktree (no clones); non-git entries are ignored. Git allows a branch in
  # only one worktree, so each stack branch maps to at most one path.
  by_branch=()
  any_wt=""
  for wt in "$WORKTREES_DIR/$project"/*(N/); do
    b=$(git -C "$wt" branch --show-current 2> /dev/null)
    [[ -n $b ]] || continue
    by_branch[$b]=$wt
    any_wt=$wt
  done

  # Bring local main up to date with origin, then push any local main commits
  # so the rebased branches aren't published on top of commits GitHub doesn't
  # have. Plain push, never forced; any worktree of the repo can push the main
  # ref. If either step fails, skip this project's stacks.
  if [[ -n $any_wt ]]; then
    sync_main "$any_wt" || {
      echo "  main: sync FAILED, skipping project" >&2
      failed=1
      continue
    }
    if [[ $(git -C "$any_wt" rev-parse main) == $(git -C "$any_wt" rev-parse -q --verify origin/main) ]]; then
      echo "  main: up to date"
    else
      out=$(git -C "$any_wt" push origin main 2>&1) || {
        echo "  main: push FAILED, skipping project" >&2
        echo "$out" >&2
        failed=1
        continue
      }
      echo "  main: pushed"
    fi
  fi

  for stack in "${STACKS[@]}"; do
    branches=(${=stack})
    paths=()
    for br in $branches; do
      [[ -n ${by_branch[$br]} ]] && paths+=("${by_branch[$br]}")
    done

    if ((${#paths} != ${#branches})); then
      echo "  skipping '$stack': missing worktree" >&2
      failed=1
      continue
    fi

    rebase_stack "${paths[@]}" || failed=1
  done
done

exit $failed
