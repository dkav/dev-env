#!/bin/zsh

# Push all repositories to Bitbucket.

set -euo pipefail

REPO_DIR="$HOME/Development"
TMP_DIR="/tmp/rpb"
found_repos=0

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM HUP

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=("$REPO_DIR"/**/.git(/N:h))
DIRS=(${DIRS:#"$REPO_DIR"/(*/|)sandbox(|/*)})
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: No directories found in $REPO_DIR."
  exit 1
fi

echo "Pushing all repositories to Bitbucket:"
echo

mkdir -p "$TMP_DIR"

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  label="${dir#$REPO_DIR/}"
  key="${label//\//__}"
  if git -C "$dir" remote | grep -q "^bitbucket$"; then
    git -C "$dir" --no-advice push bitbucket &> "$TMP_DIR/_out_$key" &
  else
    echo "Skipped: no 'bitbucket' remote." > "$TMP_DIR/_out_$key"
  fi
done
wait

for dir in "${DIRS[@]}"; do
  label="${dir#$REPO_DIR/}"
  key="${label//\//__}"
  out_file="$TMP_DIR/_out_$key"
  [[ -f "$out_file" ]] || continue
  output=$(cat "$out_file")
  printf "%s\n" "--- $label ---"
  if [[ -z $output || $output == "Everything up-to-date" ]]; then
    echo "  Already up to date."
  else
    print -r -- "$output" | sed 's/^/  /'
  fi
  echo
  rm "$out_file"
done

((found_repos)) || echo "No Git repositories found in $REPO_DIR."
