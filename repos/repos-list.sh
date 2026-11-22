#!/bin/zsh

# Make a list of all cloned repos, wherever they are under ~/Development.
# Output format, one repo per line (tab-separated):
#   <path relative to ~/Development><TAB><origin url or local source path>
# The second column is the origin url when the repo has an origin remote.
# Otherwise it is the path (relative to ~/Development) of another repo that
# has a remote pointing at this one, so it can be recreated by a local
# clone. If neither exists it is empty.

repos_dir="$HOME/Development"

# Main repos have a .git *directory*. Linked worktrees and submodules have a
# .git *file*, so -type d matches only main repos. Pruning .git avoids
# descending into it, and pruning node_modules keeps the scan fast.
repos=()
while IFS= read -r gitdir; do
  repos+=("${gitdir:h}")
done < <(
  find "$repos_dir" -name node_modules -type d -prune -o \
    -name .git -type d -print -prune 2> /dev/null
)

# Pass 1: for every remote that points at a local repo, record which repo
# points at it (absolute target path -> relative path of that repo).
typeset -A pointed_at
for repo in "${repos[@]}"; do
  while IFS= read -r url; do
    case "$url" in
      file://*) url="${url#file://}" ;;
      "~/"*) url="$HOME/${url#\~/}" ;;
      /*) ;;
      *) continue ;;
    esac
    [[ -d "$url/.git" ]] || continue
    target="${url:A}"
    [[ "$target" == "${repo:A}" ]] && continue
    pointed_at[$target]="${repo#$repos_dir/}"
  done < <(
    git --git-dir="$repo/.git" config --get-regexp '^remote\..*\.url$' \
      2> /dev/null | sed 's/^[^ ]* //'
  )
done

# Pass 2: print every repo with its origin url or, failing that, the local
# repo that points at it.
for repo in "${repos[@]}"; do
  src=$(git --git-dir="$repo/.git" remote get-url origin 2> /dev/null)
  [[ -n "$src" ]] || src="${pointed_at[${repo:A}]-}"
  printf '%s\t%s\n' "${repo#$repos_dir/}" "$src"
done \
  | sort -f
