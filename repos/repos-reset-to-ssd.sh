#!/bin/zsh
# Reset repositories to match SSD

VOLUME_PATH="/Volumes/T5 Storage"
REPO_DIR="$HOME/Repositories"
found_repos=0

# Function to safely update a repository
update_repo() {
    local repo="$1"
    local remote_name="$2"
    local branch_name="$3"

    printf "--- %s ---\n" ${repo:t}

    # Fetch from remote
    if ! git -C "$repo" fetch "$remote_name" >/dev/null 2>&1; then
        echo "  Error: Failed to fetch from $remote_name."
        return 1
    fi

    # Compare local and remote hashes
    local local_hash=$(git -C "$repo" rev-parse HEAD)
    local remote_hash=$(git -C "$repo" rev-parse "$remote_name/$branch_name" 2>/dev/null)

    if [[ -z "$remote_hash" ]]; then
        echo "  No branch '$branch_name' on remote '$remote_name'."
        return 1
    fi

    if [[ "$local_hash" == "$remote_hash" ]]; then
        echo "  Already up to date."
        return 0
    fi

    # Check for uncommitted changes
    if [[ -n $(git -C "$repo" status --porcelain) ]]; then
        echo "  Error: Uncommitted changes detected."
        return 1
    fi

    # Perform the hard reset
    echo "  Resetting to $remote_name/$branch_name..."
    if ! git -C "$repo" reset --hard "$remote_name/$branch_name" >/dev/null 2>&1; then
      echo "  Error: Failed to reset $repo_name."
      return 1
    fi
}

# Check if the drive is connected
[[ -d "$VOLUME_PATH" ]] || \
  { echo "Error: $VOLUME_PATH is not connected."; exit 1; }

[[ ! -d "$REPO_DIR" ]] && echo "Error: $REPO_DIR not found." && exit 1

DIRS=( "$REPO_DIR"/*(/) )
if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "No directories found in $REPO_DIR."
  exit 1
fi

echo "Resetting repositories to match SSD..."

for dir in "${DIRS[@]}"; do
  [[ -d "$dir/.git" ]] || continue
  found_repos=1
  update_repo "$dir" "ssd" "km"
  echo
done

(( found_repos )) || echo "No Git repositories found in $REPO_DIR."
