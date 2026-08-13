#!/bin/zsh
# Reset repositories to match SSD.
# For every repo under ~/Development (any depth) that has an ssd remote,
# hard-reset the checked-out branch to ssd/<branch> -- but only when that
# branch is the one checked out.

VOLUME_PATH="/Volumes/T5 Storage"
DEV_DIR="$HOME/Development"
BRANCH="tk"

# Function to safely update a repository
update_repo() {
  local repo="$1"
  local remote_name="$2"
  local branch_name="$3"
  local label="${repo#$DEV_DIR/}"
  local current

  printf "%s\n" "--- $label ---"

  # reset --hard moves whatever is checked out, so only proceed when that is
  # the branch we mean to reset (and not, say, main).
  current=$(git -C "$repo" branch --show-current)
  if [[ "$current" != "$branch_name" ]]; then
    echo "  Skipped: $branch_name is not checked out (on '${current:-detached HEAD}')."
    return 0
  fi

  # Fetch from remote
  if ! git -C "$repo" fetch "$remote_name" > /dev/null 2>&1; then
    echo "  Error: Failed to fetch from $remote_name."
    return 1
  fi

  # Compare local and remote hashes
  local local_hash=$(git -C "$repo" rev-parse HEAD)
  local remote_hash=$(git -C "$repo" rev-parse "$remote_name/$branch_name" 2> /dev/null)

  if [[ -z "$remote_hash" ]]; then
    echo "  Skipped: no branch '$branch_name' on remote '$remote_name'."
    return 1
  fi

  if [[ "$local_hash" == "$remote_hash" ]]; then
    echo "  Already up to date ($branch_name @ ${local_hash[1,7]})."
    return 0
  fi

  # Check for uncommitted changes
  if [[ -n $(git -C "$repo" status --porcelain) ]]; then
    echo "  Error: Uncommitted changes detected. Aborting."
    return 1
  fi

  # Perform the hard reset
  echo "  Resetting $branch_name to $remote_name/$branch_name"
  if ! git -C "$repo" reset --hard "$remote_name/$branch_name" > /dev/null 2>&1; then
    echo "  Error: Failed to reset $label."
    return 1
  fi
  echo "  Done (${local_hash[1,7]} -> ${remote_hash[1,7]})."
}

# Check if the drive is connected
[[ -d "$VOLUME_PATH" ]] \
  || {
    echo "Error: $VOLUME_PATH is not connected."
    exit 1
  }

[[ ! -d "$DEV_DIR" ]] && echo "Error: $DEV_DIR not found." && exit 1

# Main repos have a .git *directory*; linked worktrees and submodules have a
# .git *file*, so -type d matches only main repos. Pruning .git avoids
# descending into it, and pruning node_modules keeps the scan fast.
repos=()
while IFS= read -r gitdir; do
  repo="${gitdir:h}"
  git -C "$repo" remote get-url ssd &> /dev/null && repos+=("$repo")
done < <(
  find "$DEV_DIR" -name node_modules -type d -prune -o \
    -name .git -type d -print -prune 2> /dev/null | sort
)

if [[ ${#repos[@]} -eq 0 ]]; then
  echo "No Git repositories with an ssd remote found in $DEV_DIR."
  exit 0
fi

echo "Resetting repositories to match SSD:"
echo

for repo in "${repos[@]}"; do
  update_repo "$repo" "ssd" "$BRANCH"
  echo
done
