#!/bin/zsh

REPO_DIR="$HOME/Repositories"

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

cd "$REPO_DIR" || exit 1

DIRS=( *(/N) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "No repositories found."
  exit 1
fi

echo "Checking for Git stashes in all repositories..."

for dir in "${DIRS[@]}"; do
  [[ -d "$REPO_DIR/$dir/.git" ]] || continue
  stashes=$(git -C "$REPO_DIR/$dir" stash list)
  if [[ -n "$stashes" ]]; then
    print -P "\n%F{cyan}%B--- $dir ---%b%f"
    echo "$stashes"
  fi
done
