#!/bin/zsh

# Update outdated base Python packages.

setopt extended_glob

function print_updates() {
  # $1 - label for "no updates" message
  local had_output=false
  local header=""
  local -A removed=()
  local -A added=()
  local -a order=()

  _flush_block() {
    local pkg
    if (( ${#order[@]} )); then
      [[ -n "$header" ]] && echo "$header"
      for pkg in "${order[@]}"; do
        if [[ -n "${removed[$pkg]}" && -n "${added[$pkg]}" ]]; then
          echo "$pkg ${removed[$pkg]} -> ${added[$pkg]}"
        elif [[ -n "${removed[$pkg]}" ]]; then
          echo "$pkg ${removed[$pkg]} (removed)"
        elif [[ -n "${added[$pkg]}" ]]; then
          echo "$pkg ${added[$pkg]} (added)"
        fi
        had_output=true
      done
    fi
    removed=()
    added=()
    order=()
  }

  while IFS= read -r line; do
    if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
      echo "$line"
      had_output=true
    elif [[ "$line" =~ "^(Updated|Upgraded|Upgrading|Updating|Modified) ([^ .]+)" ]]; then
      _flush_block
      header="--- ${match[2]} ---"
    elif [[ "$line" =~ "^ - (.+)==(.+)$" ]]; then
      local pkg="${match[1]}"
      removed[$pkg]="${match[2]}"
      (( ${order[(Ie)$pkg]} )) || order+=("$pkg")
    elif [[ "$line" =~ "^ \+ (.+)==(.+)$" ]]; then
      local pkg="${match[1]}"
      added[$pkg]="${match[2]}"
      (( ${order[(Ie)$pkg]} )) || order+=("$pkg")
    fi
  done
  _flush_block
  [[ $had_output == false ]] && echo "No $1 updates"
}

function venv_update() {
  # $1 - venv name; $2 - path to req file
  printf "\nUpdate %s virtual environment:\n" $1
  print_updates "$1 package" < <(uv pip install \
    --python "$HOME/.local/pyvenvs/$1/bin/python" \
    --exact --upgrade --no-progress -r "$2/venv-$1-reqs.in" 2>&1)
}

echo "Updating Python Packages..."
if (( $+commands[uv] )); then
  echo "Update Python apps:"
  print_updates "app" < <(uv tool upgrade --all \
    --no-progress --color never 2>&1)

  req_path=${0:a:h}
  venv_update mlx $req_path
  venv_update pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi
