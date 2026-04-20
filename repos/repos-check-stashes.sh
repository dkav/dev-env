#!/bin/zsh

REPO_DIR="$HOME/Repositories"
found_repos=0

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=( "$REPO_DIR"/*(/) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "No directories found in $REPO_DIR."
  exit 1
fi

echo "Checking for Git stashes..."

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  stashes=$(git -C "$dir" stash list)
  if [[ -n "$stashes" ]]; then
    printf "\n--- ${dir:t} ---\n"
    echo "$stashes"
  fi
done

(( found_repos )) || echo "No Git repositories found in $REPO_DIR."
