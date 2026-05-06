#!/bin/zsh

# Rebase worktrees and push to GitHub.

WORKTREES_DIR="$HOME/Worktrees"
TMP_DIR="/tmp/rrw"

function rb_push_br() {
  local repo=$1
  local logfile="$TMP_DIR/${repo:t}.log"

  {
    git -C "$repo" rebase main && git -C "$repo" push --force
  } &> "$logfile"

  return $?
}

if [[ ! -d "$WORKTREES_DIR" ]]; then
  echo "Worktrees directory not found: $WORKTREES_DIR" >&2
  exit 1
fi

mkdir -p "$TMP_DIR"
trap 'rm -rf $TMP_DIR' EXIT

echo "Rebasing worktrees and pushing to GitHub:"

WORKTREES=()
for dir in "$WORKTREES_DIR"/*(N/); do
  if [[ -f "$dir/.git" ]] && grep -q "^gitdir:" "$dir/.git" 2>/dev/null; then
    WORKTREES+=("$dir")
    rb_push_br "$dir" &
  fi
done

if (( ${#WORKTREES} == 0 )); then
  echo "No Git worktrees found in $WORKTREES_DIR." >&2
  exit 1
fi

wait

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

$any_output || echo "All worktrees are up to date."
