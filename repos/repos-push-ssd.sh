#!/bin/zsh

# Push all ~/Repositories repos with an ssd remote to ssd.

VOLUME_PATH="/Volumes/T5 Storage"
REPO_DIR="$HOME/Repositories"
found_repos=0

echo "Pushing repositories with ssd remote:"

# Check if the drive is connected
[[ -d "$VOLUME_PATH" ]] \
  || {
    echo "Error: $VOLUME_PATH is not connected."
    exit 1
  }

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=("$REPO_DIR"/*(/))
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: No directories found in $REPO_DIR."
  exit 1
fi

ssd_repos=()
for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  git -C "$dir" remote get-url ssd &> /dev/null && ssd_repos+=("$dir")
done

for ((i = 1; i <= ${#ssd_repos[@]}; i++)); do
  dir=${ssd_repos[$i]}
  printf "--- %s ---\n" ${dir:t}
  git -C "$dir" push ssd --force --all
  ((i < ${#ssd_repos[@]})) && echo
done

((found_repos)) || echo "No Git repositories found in $REPO_DIR."
