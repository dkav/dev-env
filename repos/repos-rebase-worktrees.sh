#!/bin/zsh

# Rebase worktrees and push to GitHub.
#
# Worktrees are discovered either directly in WORKTREES_DIR or one level down
# in project folders, e.g.:
#   $HOME/Development/wktrees/project1/project1-wktree

WORKTREES_DIR="$HOME/Development/wktrees"
TMP_DIR="/tmp/rrw"

# Path relative to WORKTREES_DIR, used for display and log names.
function rel_name() {
  echo "${1#$WORKTREES_DIR/}"
}

# Log file path; slashes are flattened so identically named worktrees in
# different projects don't overwrite each other's logs.
function log_path() {
  local name=$(rel_name "$1")
  echo "$TMP_DIR/${name//\//__}.log"
}

# A linked worktree has a .git *file* containing "gitdir: ...".
function is_worktree() {
  [[ -f "$1/.git" ]] && grep -q "^gitdir:" "$1/.git" 2> /dev/null
}

function rb_push_br() {
  local repo=$1
  local logfile=$(log_path "$repo")

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
  if is_worktree "$dir"; then
    # Worktree sitting directly in WORKTREES_DIR.
    WORKTREES+=("$dir")
  else
    # Treat as a project folder and look one level down.
    for sub in "$dir"/*(N/); do
      is_worktree "$sub" && WORKTREES+=("$sub")
    done
  fi
done

if ((${#WORKTREES} == 0)); then
  echo "No Git worktrees found in $WORKTREES_DIR." >&2
  exit 1
fi

MAX_PARALLEL=3
running=0
for wt in "${WORKTREES[@]}"; do
  rb_push_br "$wt" &
  ((running++))
  if ((running >= MAX_PARALLEL)); then
    wait -n 2> /dev/null || wait
    ((running--))
  fi
done
wait

any_output=false
for wt in "${WORKTREES[@]}"; do
  logfile=$(log_path "$wt")
  name=$(rel_name "$wt")
  if [[ -f "$logfile" ]]; then
    output=$(grep -Ev \
      "^Current branch|^Everything up-to-date|^Already up to date\.$" \
      "$logfile")
    if [[ -n "$output" ]]; then
      any_output=true
      printf "=== %s ===\n" "$name"
      if echo "$output" | grep -q "rebase.*in progress\|rebase-merge\|rebase-apply"; then
        echo "Error: A rebase is already in progress in $wt. Please resolve manually."
      else
        printf "%s\n\n" $output
      fi
    fi
  fi
done

$any_output || echo "All worktrees are up to date."
