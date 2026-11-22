#!/bin/zsh

# Push all ~/Development/ repos (at any depth) with an ssd remote to ssd.

VOLUME_PATH="/Volumes/T5 Storage"
DEV_DIR="$HOME/Development"

# Check if the drive is connected
[[ -d "$VOLUME_PATH" ]] \
  || {
    echo "Error: $VOLUME_PATH is not connected."
    exit 1
  }

[[ ! -d "$DEV_DIR" ]] && echo "Error: $DEV_DIR not found." && exit 1

# Find every directory containing a .git directory, skipping node_modules.
# Linked worktrees have a .git file rather than a directory, so they are
# not matched (and share the main repo's remotes anyway).
repo_dirs=()
while IFS= read -r gitdir; do
  repo_dirs+=("${gitdir:h}")
done < <(
  find "$DEV_DIR" -type d -name node_modules -prune -o \
    -type d -name .git -print -prune 2> /dev/null | sort
)

if [[ ${#repo_dirs[@]} -eq 0 ]]; then
  echo "No Git repositories found in $DEV_DIR."
  exit 0
fi

ssd_repos=()
for dir in "${repo_dirs[@]}"; do
  git -C "$dir" remote get-url ssd &> /dev/null && ssd_repos+=("$dir")
done

if [[ ${#ssd_repos[@]} -eq 0 ]]; then
  echo "No Git repositories with an ssd remote found in $DEV_DIR."
  exit 0
fi

echo "Pushing repositories with ssd remote:"
echo

for dir in "${ssd_repos[@]}"; do
  printf "%s\n" "--- ${dir#$DEV_DIR/} ---"
  if ! out=$(git -C "$dir" push ssd --force --all 2>&1); then
    echo "  Error: Push to ssd failed."
    print -r -- "$out" | sed 's/^/    /'
  elif [[ $out == "Everything up-to-date" ]]; then
    echo "  Already up to date."
  else
    echo "  Pushed to ssd."
    print -r -- "$out" | sed 's/^/    /'
  fi
  echo
done
