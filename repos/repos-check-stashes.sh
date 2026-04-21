#!/bin/zsh

# List all Git stashes in ~/Repositories.

REPO_DIR="$HOME/Repositories"
found_repos=0
found_stashes=0

echo "Checking for Git stashes:"

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=( "$REPO_DIR"/*(/) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "Error: No directories found in $REPO_DIR."
  exit 1
fi

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  stashes=$(git -C "$dir" stash list)
  if [[ -n "$stashes" ]]; then
    found_stashes=1
    printf "--- %s ---\n" ${dir:t}
    printf "%s\n\n" $stashes
  fi
done

(( found_repos )) || echo "No Git repositories found in $REPO_DIR."
(( found_stashes )) || echo "No stashes found."
