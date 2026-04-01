#!/bin/zsh
# Push all ~/Repositories repos with an ssd remote to ssd

REPO_DIR="$HOME/Repositories"

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

cd "$REPO_DIR" || exit 1

DIRS=( *(/N) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "No repositories found."
  exit 1
fi

echo "Pushing repositories with ssd remote to ssd..."

for dir in "${DIRS[@]}"; do
  if [[ -d "$dir/.git" ]] && git -C "$dir" remote get-url ssd &>/dev/null; then
    printf "\nProcessing %s...\n" "$dir"
    git -C "$dir" push ssd --force --all
  fi
done
