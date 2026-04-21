#!/bin/zsh

# Rebase worktrees and push to GitHub.

REPO_DIR="$HOME/Repositories"
TMP_DIR="/tmp/rrw"
found_repos=0

function rb_push_br() {
  local repo=$1
  local logfile="$TMP_DIR/${repo:t}.log"

  {
    git -C "$repo" rebase main && git -C "$repo" push --force
  } &> "$logfile"

  return $?
}

WORKTREES=( "$HOME/Repositories"/*-wt-*(/N) )

if (( ${#WORKTREES} == 0 )); then
  echo "No worktree repos found in $REPO_DIR" >&2
  exit 1
fi

mkdir -p "$TMP_DIR"
trap 'rm -rf $TMP_DIR' EXIT

echo "Rebasing worktrees and pushing to GitHub:"

for wt in "${WORKTREES[@]}"; do
  [[ -f "$wt/.git" ]] || continue
  found_repos=1
  rb_push_br "$wt" &
done

wait

if (( found_repos )); then
  any_output=false
  for wt in "${WORKTREES[@]}"; do
    logfile="$TMP_DIR/${wt:t}.log"
    if [[ -f "$logfile" ]]; then
      output=$(grep -Ev \
        "^Current branch|^Everything up-to-date|^Already up to date\.$" \
        "$logfile")
      if [[ -n "$output" ]]; then
        any_output=true
        printf "=== %s ===\n" "${wt:t}"
        printf "%s\n\n" $output
      fi
    fi
  done
  $any_output || echo "All worktress are up to date."
else
  echo "No Git repositories found in $REPO_DIR."
fi
