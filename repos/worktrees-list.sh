#!/bin/zsh

# List all worktrees (excluding main) for each repo in the Repositories directory.

repos_dir="$HOME/Repositories"

find "$repos_dir" -maxdepth 1 -type d -not -path "$repos_dir" \
  | while read -r repo; do
      [[ -d "$repo/.git" ]] || continue
      git --git-dir="$repo/.git" worktree list 2>/dev/null | tail -n +2
    done
