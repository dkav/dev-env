#!/bin/zsh
# Push all ~/Repositories repos with an ssd remote to ssd

VOLUME_PATH="/Volumes/T5 Storage"
REPO_DIR="$HOME/Repositories"
found_repos=0

# Check if the drive is connected
[[ -d "$VOLUME_PATH" ]] || \
  { echo "Error: $VOLUME_PATH is not connected."; exit 1; }

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=( "$REPO_DIR"/*(/) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "No directories found in $REPO_DIR."
  exit 1
fi

echo "Pushing repositories with ssd remote..."

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  if git -C "$dir" remote get-url ssd &>/dev/null; then
    printf "\n--- ${dir:t} ---\n"
    git -C "$dir" push ssd --force --all
  fi
done

(( found_repos )) || echo "No Git repositories found in $REPO_DIR."
