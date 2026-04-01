#!/bin/zsh
# Push all ~/Repositories repos with an ssd remote to ssd

echo "Pushing repositories with ssd remote to ssd..."

for repo_path in "$HOME/Repositories"/*/; do
  repo=$(basename "$repo_path")

  if ! cd "$repo_path" 2>/dev/null; then
    printf "Error: Could not access %s\n" "$repo" >&2
    continue
  fi

  if git rev-parse --git-dir &>/dev/null && \
     git remote get-url ssd &>/dev/null; then
    printf "\nProcessing %s...\n" "$repo"
    git push ssd --force --all
  fi
done
