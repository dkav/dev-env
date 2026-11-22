#!/bin/zsh

# List all linked worktrees (excluding each repo's main worktree) for every
# git repository found anywhere in or below ~/Development.
#
# Output is tab-separated, one worktree per line:
#   <repo path>  <worktree path>  <ref>
# where ref is the branch name, or "detached:<commit>" for a detached
# worktree (branch names cannot contain a colon, so the two never clash).
# Redirect to a file for use with create-worktrees.sh.

dev_dir="$HOME/Development"

# Main repos have a .git *directory*; linked worktrees and submodules have a
# .git *file*, so -type d matches only the main repos. Pruning .git avoids
# descending into it, and pruning node_modules keeps the scan fast.
find "$dev_dir" -name node_modules -type d -prune -o \
  -name .git -type d -print -prune 2> /dev/null \
  | while IFS= read -r gitdir; do
    repo="${gitdir:h}"
    git -C "$repo" worktree list --porcelain 2> /dev/null | awk -v repo="$repo" '
      function flush() {
        # n == 1 is the main worktree; skip it.
        if (p != "" && n > 1) {
          if (b != "") printf "%s\t%s\t%s\n", repo, p, b
          else printf "%s\t%s\tdetached:%s\n", repo, p, h
        }
        p = ""; b = ""; h = ""
      }
      /^worktree / { flush(); n++; p = substr($0, 10) }
      /^HEAD /     { h = substr($0, 6) }
      /^branch /   { b = substr($0, 8); sub(/^refs\/heads\//, "", b) }
      END          { flush() }
    '
  done \
  | sort -u
