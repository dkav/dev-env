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

worktrees=( "$HOME/Repositories"/*-wt-*(/N) )

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

any_output=false
for wt in "${worktrees[@]}"; do
  logfile="$tmpdir/${wt}.log"
  if [[ -f "$logfile" ]]; then
    output=$(grep -Ev "^Current branch|^Everything up-to-date|^Already up to date\.$" "$logfile")
    if [[ -n "$output" ]]; then
      any_output=true
      printf "\n=== %s ===\n" "$wt"
      echo "$output"
    fi
  fi
done

$any_output || echo "Everything up-to-date"
