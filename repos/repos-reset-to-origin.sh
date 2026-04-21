#!/bin/zsh
# Reset repositories to match origin on GitHub.

export PATH=/opt/local/bin:/opt/local/sbin:$PATH

REPO_DIR="$HOME/Repositories"
EXCLUDED_REPOS=("macports-ports")

# Function to safely reset a repository to match origin.
update_repo() {
    local repo="$1"
    local remote_name="$2"
    local repo_name="${repo:t}"

    printf "--- %s ---\n" $repo_name

    # Get the currently checked out branch
    local branch_name=$(git -C "$repo" symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$branch_name" ]]; then
        echo "  Error: Not on a branch (detached HEAD). Skipping."
        return 1
    fi

    # Fetch from remote
    if ! git -C "$repo" fetch "$remote_name" >/dev/null 2>&1; then
        echo "  Error: Failed to fetch from $remote_name."
        return 1
    fi

    # Check remote branch exists
    local remote_hash=$(git -C "$repo" rev-parse "$remote_name/$branch_name" 2>/dev/null)
    if [[ -z "$remote_hash" ]]; then
        echo "  No branch '$branch_name' on remote '$remote_name'. Skipping."
        return 1
    fi

    # Compare local and remote hashes
    local local_hash=$(git -C "$repo" rev-parse HEAD)
    if [[ "$local_hash" == "$remote_hash" ]]; then
        echo "  Already up to date. Skipping reset."
        return 0
    fi

    # Check for uncommitted changes
    if [[ -n $(git -C "$repo" status --porcelain) ]]; then
        echo "  Error: Uncommitted changes detected. Aborting."
        return 1
    fi

    # Perform the hard reset
    echo "  Resetting to $remote_name/$branch_name..."
    if git -C "$repo" reset --hard "$remote_name/$branch_name" >/dev/null; then
        echo "  Successfully reset to $remote_name/$branch_name."
    else
        echo "  Error: Failed to reset $repo_name."
        return 1
    fi
}

# --- Execution ---
echo "Resetting repositories to match origin..."

for repo in "$REPO_DIR"/*/; do
    repo="${repo%/}"
    [[ -d "$repo/.git" ]] || continue
    [[ ${EXCLUDED_REPOS[(ie)${repo:t}]} -le ${#EXCLUDED_REPOS} ]] && continue
    update_repo "$repo" "origin"
    echo
done
