#!/bin/zsh

# List all Git stashes in every repo found anywhere under ~/Development.

export PATH=/opt/local/bin:/opt/local/sbin:$PATH

DEV_DIR="$HOME/Development"
found_repos=0
found_stashes=0

echo "Checking for Git stashes:"

[[ ! -d "$DEV_DIR" ]] && echo "Error: $DEV_DIR not found." && exit 1

# Main repos have a .git *directory*. Linked worktrees and submodules have a
# .git *file*, so -type d matches only main repos. Pruning .git avoids
# descending into it, and pruning node_modules keeps the scan fast.
repos=()
while IFS= read -r gitdir; do
  repos+=("${gitdir:h}")
done < <(
  find "$DEV_DIR" -name node_modules -type d -prune -o \
    -name .git -type d -print -prune 2> /dev/null | sort
)

for dir in "${repos[@]}"; do
  found_repos=1
  stashes=$(git -C "$dir" stash list 2> /dev/null)
  if [[ -n "$stashes" ]]; then
    found_stashes=1
    printf -- "--- %s ---\n" "${dir#$DEV_DIR/}"
    printf "%s\n\n" "$stashes"
  fi
done

((found_repos)) || echo "No Git repositories found in $DEV_DIR."
((found_repos && ! found_stashes)) && echo "No stashes found."
