#!/bin/zsh
# Rebase worktrees and push to GitHub

function rb_push_br() {
  local repo=$1
  local logfile="$tmpdir/${repo}.log"

  {
    if ! cd "$HOME/Repositories/$repo" 2>/dev/null; then
      echo "Error: Could not access $repo" >&2
      return 1
    fi

    git rebase main && git push --force
  } &> "$logfile"

  return $?
}

worktrees=("${(@f)$(ls -1 "$HOME/Repositories" | grep -- '-wt-')}")

if (( ${#worktrees} == 0 )); then
  echo "No worktree repos found in ~/Repositories" >&2
  exit 1
fi

tmpdir="/tmp/rrw"
mkdir -p "$tmpdir"
trap 'rm -rf $tmpdir' EXIT

echo "Rebasing worktrees and pushing to GitHub..."

for wt in "${worktrees[@]}"; do
  rb_push_br "$wt" &
done

wait

for wt in "${worktrees[@]}"; do
  printf "\n=== %s ===\n" $wt
  cat "$tmpdir/${wt}.log"
done
