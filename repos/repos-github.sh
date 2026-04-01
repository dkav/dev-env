#!/bin/zsh
# Fetch, pull, push and sync all GitHub repositories

set -euo pipefail

readonly TMP_DIR="/tmp/gb"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM HUP

if [ -d "$HOME/Repositories/" ]; then
  cd "$HOME/Repositories/"
else
  echo "No Repositories directory" >&2
  exit 1
fi

DIRS=( *(/N) )
if [ ${#DIRS[@]} -eq 0 ]; then
  echo "No repositories"
  exit 1
fi

check_tracking_branch() {
  local dir="$1"
  local branch
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null) || return 1
  git -C "$dir" rev-parse --verify "origin/$branch" &>/dev/null || return 1
}

print_output() {
  for dir in "${DIRS[@]}"; do
    out_file="$TMP_DIR/_out_$dir"
    if [[ -f "$out_file" ]]; then
      output=$(cat "$out_file")
      if [[ $output != "Everything up-to-date" \
        && $output != "Already up to date." && -n "$output" ]]; then
        printf "\n%s:\n%s\n" "$dir" "$output"
      fi
      rm -f "$out_file"
    fi
  done
}

git_exec() {
  printf "${(C)1}ing all repositories...\n"
  mkdir -p "$TMP_DIR"
  local dir
  for dir in "${DIRS[@]}"; do
    [[ -d "$dir/.git" ]] || continue
    (
      [[ -n "${3:-}" ]] && { "${3}" "$dir" || exit 0; }
      git -C "$dir" "$1" $=2
    ) &> "$TMP_DIR/_out_$dir" &
  done
  wait
  print_output
}

sync_forks() {
  echo "Syncing all forked repositories on GitHub..."

  if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) not found. Please install it." >&2
    exit 1
  fi

  local quiet=false
  local OPTIND=1
  while getopts ":q" opt; do
    case "$opt" in
      q)
        quiet=true ;;
      \?) echo "Invalid option for sync: -$OPTARG" >&2; exit 1 ;;
    esac
  done

  local repos
  local repo
  repos=( $(gh repo list --fork --json name --jq '.[].name') )
  mkdir -p "$TMP_DIR"

  for repo in "${repos[@]}"; do
    gh repo sync "dkav/$repo" &> "$TMP_DIR/_out_$repo" &
  done
  wait

  for repo in "${repos[@]}"; do
    out_file="$TMP_DIR/_out_$repo"
    if [[ -s "$out_file" ]]; then
      echo "$repo:"
      cat "$out_file"
    else
      if ! $quiet; then
         echo "$repo: Synced"
      fi
    fi
    rm -f "$out_file"
  done
}

case "${1:-}" in
  fetch)  git_exec "fetch" "" ;;
  pull)   git_exec "pull" "--ff-only" check_tracking_branch ;;
  push)   git_exec "push" "origin" check_tracking_branch ;;
  sync)   sync_forks "${@:2}" ;;
  *)      echo "Usage: ${0:t} {fetch|pull|push|sync}"; exit 1 ;;
esac

exit 0
