#!/opt/local/bin/zsh

# Fetch, pull, push and sync all GitHub repositories.

setopt extended_glob
set -uo pipefail
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

REPO_DIR="$HOME/Repositories"
TMP_DIR="/tmp/gb"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM HUP

check_tracking_branch() {
  local dir="$1"
  local branch
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null) || return 1
  git -C "$dir" rev-parse --verify "origin/$branch" &>/dev/null || return 1
}

print_output() {
  local -a DIRS=("$@")
  local any_output=0

  for dir in "${DIRS[@]}"; do
    out_file="$TMP_DIR/_out_${dir:t}"
    if [[ -f "$out_file" ]]; then
      output=$(cat "$out_file")
      if [[ $output != "Everything up-to-date" \
        && $output != "Already up to date." && -n "$output" ]]; then
        printf "--- %s ---\n" ${dir:t}
        printf "%s\n\n" $output
        any_output=1
      fi
      rm -f "$out_file"
    fi
  done
  (( any_output )) || echo "All repositories are up to date."
}

git_exec() {
  local GIT_CMD=$1
  local GIT_OPT=${2:-}
  local BRANCH=${3:-}
  local found_repos=0
  local dir

  printf "%sing all repositories:\n" ${(C)1}

  [[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

  DIRS=( "$REPO_DIR"/*~*macports-ports*(/N) )
  if [[ ${#DIRS[@]} -eq 0 ]]; then
    echo "Error: No directories found in $REPO_DIR."
    exit 1
  fi

  mkdir -p "$TMP_DIR"
  for dir in "${DIRS[@]}"; do
    [[ -d "$dir/.git" ]] || continue
    found_repos=1
    (
      [[ -n "$BRANCH" ]] && { "${BRANCH}" "$dir" || exit 0; }
      git -C "$dir" "$GIT_CMD" $=GIT_OPT
    ) &> "$TMP_DIR/_out_${dir:t}" &
  done
  wait

  if (( found_repos )); then
     print_output "${DIRS[@]}"
  else
     echo "Error: No Git repositories found in $REPO_DIR."
  fi
}

sync_forks() {
  local OPTIND=1
  local quiet=0
  local no_output=1
  local repos
  local repo

  echo "Syncing all forked repositories on GitHub:"

  if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) not found. Please install it." >&2
    exit 1
  fi

  while getopts ":q" opt; do
    case "$opt" in
      q)
        quiet=1 ;;
      \?) echo "Error: Invalid option for sync: -$OPTARG" >&2; exit 1 ;;
    esac
  done

  repos=( $(gh repo list --fork --limit 500 --json name --jq '.[].name') )
  mkdir -p "$TMP_DIR"

  for repo in "${repos[@]}"; do
    gh repo sync "dkav/$repo" &> "$TMP_DIR/_out_$repo" &
  done
  wait

  for repo in "${repos[@]}"; do
    out_file="$TMP_DIR/_out_$repo"
    if [[ -s "$out_file" ]]; then
      no_output=0
      echo "$repo:"
      cat "$out_file"
    else
      if (( ! quiet )); then
         echo "$repo: Synced"
      fi
    fi
    rm -f "$out_file"
  done

 (( no_output && quiet )) && echo "All forks sync'ed."
}

case "${1:-}" in
  fetch)  git_exec "fetch" ;;
  pull)   git_exec "pull" "--ff-only" check_tracking_branch ;;
  push)   git_exec "push" "origin" check_tracking_branch ;;
  sync)   sync_forks "${@:2}" ;;
  *)      echo "Usage: ${0:t} {fetch|pull|push|sync}"; exit 1 ;;
esac

exit 0
