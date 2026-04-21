#!/bin/zsh
# Push all repositories to Bitbucket

set -euo pipefail

REPO_DIR="$HOME/Repositories"
TMP_DIR="/tmp/rpb"
found_repos=0

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM HUP

echo "Pushing all repositories to Bitbucket:"

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=( "$REPO_DIR"/*(/) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: No directories found in $REPO_DIR."
  exit 1
fi

mkdir -p "$TMP_DIR"

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  if git -C "$dir" remote | grep -q "^bitbucket$"; then
    git -C "$dir" --no-advice push bitbucket &> "$TMP_DIR/_out_${dir:t}" &
  else
    echo "  No 'bitbucket' remote found" > "$TMP_DIR/_out_${dir:t}"
  fi
done
wait

all_up_to_date=1

for dir in "${DIRS[@]}"; do
  out_file="$TMP_DIR/_out_${dir:t}"
  [[ -f "$out_file" ]] || continue
  output=$(cat "$out_file")
  if [[ $output != "Everything up-to-date" ]]; then
    all_up_to_date=0
    printf "--- %s ---\n" ${dir:t}
    printf "%s\n\n" $output
  fi
  rm "$out_file"
done

(( found_repos )) || echo "No Git repositories found in $REPO_DIR."
(( all_up_to_date )) && echo "All repositories are up to date."
