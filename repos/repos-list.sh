#!/bin/zsh

# Make a list of all cloned repos.

setup_dir=${0:A:h}
repos_dir="$HOME/Repositories"

find "$repos_dir" -maxdepth 1 -type d -not -path "$repos_dir" \
  | while read -r repo; do
      [[ -d "$repo/.git" ]] && git --git-dir="$repo/.git" remote get-url origin 2>/dev/null
    done \
  | sort -f
