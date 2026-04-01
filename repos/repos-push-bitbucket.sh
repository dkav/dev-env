#!/bin/zsh
# Push all repositories to Bitbucket

set -euo pipefail

echo "Pushing all repositories to Bitbucket..."

TMP_DIR="/tmp/rpb"

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

mkdir -p "$TMP_DIR"

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  if git -C "$dir" remote | grep -q "^bitbucket$"; then
    git -C "$dir" --no-advice push bitbucket &> "$TMP_DIR/_out_$dir" &
  else
    echo "  No 'bitbucket' remote found" > "$TMP_DIR/_out_$dir"
  fi
done
wait

for dir in "${DIRS[@]}"; do
  out_file="$TMP_DIR/_out_$dir"
  output=$(cat "$out_file")
  if [[ $output != "Everything up-to-date" ]]; then
    echo "$dir:"
    echo "$output"
  fi
  rm "$out_file"
done
