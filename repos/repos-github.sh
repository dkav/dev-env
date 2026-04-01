#!/opt/local/bin/zsh

# Fetch, pull, push and sync all GitHub repositories.

set -uo pipefail
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

DEV_DIR="$HOME/Development"
TMP_DIR="/tmp/gb"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM HUP

# Path relative to DEV_DIR, e.g. repos/dotfiles
repo_label() {
  print -r -- "${1#$DEV_DIR/}"
}

# Unique, filename-safe key, e.g. repos__dotfiles
repo_key() {
  local rel
  rel=$(repo_label "$1")
  print -r -- "${rel//\//__}"
}

# Populate REPOS with every repo under DEV_DIR (any depth) that has at least
# one remote. Skips node_modules and sandbox directories. Linked worktrees
# have a .git file rather than a directory, so they are not matched.
find_repos() {
  local gitdir dir
  REPOS=()
  while IFS= read -r gitdir; do
    dir=${gitdir:h}
    [[ -n "$(git -C "$dir" remote 2> /dev/null)" ]] || continue
    REPOS+=("$dir")
  done < <(
    find "$DEV_DIR" \( -name node_modules -o -name sandbox \) -type d -prune -o \
      -type d -name .git -print -prune 2> /dev/null | sort
  )
}

check_tracking_branch() {
  local dir="$1"
  local branch
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2> /dev/null) || return 1
  git -C "$dir" rev-parse --verify "origin/$branch" &> /dev/null || return 1
}

# Print one "--- repo ---" block per repository, with its output indented.
print_output() {
  local -a DIRS=("$@")
  local dir out_file output branch hash

  for dir in "${DIRS[@]}"; do
    out_file="$TMP_DIR/_out_$(repo_key "$dir")"
    [[ -f "$out_file" ]] || continue
    output=$(cat "$out_file")
    printf "%s\n" "--- $(repo_label "$dir") ---"
    if [[ -z $output || $output == "Everything up-to-date" ||
      $output == "Already up to date." ]]; then
      branch=$(git -C "$dir" branch --show-current 2> /dev/null)
      hash=$(git -C "$dir" rev-parse --short=7 HEAD 2> /dev/null)
      echo "  Already up to date (${branch:-detached HEAD} @ $hash)."
    else
      print -r -- "$output" | sed 's/^/  /'
    fi
    echo
    rm -f "$out_file"
  done
}

git_exec() {
  local GIT_CMD=$1
  local GIT_OPT=${2:-}
  local BRANCH=${3:-}
  local dir

  [[ ! -d "$DEV_DIR" ]] && echo "Error: $DEV_DIR not found." && exit 1

  find_repos
  if [[ ${#REPOS[@]} -eq 0 ]]; then
    echo "No Git repositories with a remote found in $DEV_DIR."
    exit 0
  fi

  printf "%sing all repositories:\n\n" ${(C)1}

  mkdir -p "$TMP_DIR"
  for dir in "${REPOS[@]}"; do
    (
      if [[ -n "$BRANCH" ]] && ! "${BRANCH}" "$dir"; then
        echo "Skipped: current branch has no origin counterpart."
        exit 0
      fi
      git -C "$dir" "$GIT_CMD" $=GIT_OPT
    ) &> "$TMP_DIR/_out_$(repo_key "$dir")" &
  done
  wait

  print_output "${REPOS[@]}"
}

sync_forks() {
  local OPTIND=1
  local quiet=0
  local no_output=1
  local repos
  local repo

  echo "Syncing all forked repositories on GitHub:"
  echo

  if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) not found. Please install it." >&2
    exit 1
  fi

  while getopts ":q" opt; do
    case "$opt" in
      q)
        quiet=1
        ;;
      \?)
        echo "Error: Invalid option for sync: -$OPTARG" >&2
        exit 1
        ;;
    esac
  done

  repos=($(gh repo list --fork --limit 500 --json name --jq '.[].name'))
  mkdir -p "$TMP_DIR"

  for repo in "${repos[@]}"; do
    (
      branch=$(gh api "repos/dkav/$repo" --jq '.parent.default_branch') || exit 1
      gh repo sync "dkav/$repo" -b "$branch"
    ) &> "$TMP_DIR/_out_$repo" &
  done
  wait

  for repo in "${repos[@]}"; do
    out_file="$TMP_DIR/_out_$repo"
    if [[ -s "$out_file" ]]; then
      no_output=0
      printf "%s\n" "--- $repo ---"
      sed 's/^/  /' "$out_file"
      echo
    else
      if ((! quiet)); then
        printf "%s\n" "--- $repo ---"
        echo "  Synced."
        echo
      fi
    fi
    rm -f "$out_file"
  done

  ((no_output && quiet)) && echo "All forks sync'ed."
}

case "${1:-}" in
  fetch) git_exec "fetch" ;;
  pull) git_exec "pull" "--ff-only" check_tracking_branch ;;
  push) git_exec "push" "origin" check_tracking_branch ;;
  sync) sync_forks "${@:2}" ;;
  *)
    echo "Usage: ${0:t} {fetch|pull|push|sync}"
    exit 1
    ;;
esac

exit 0
