#!/bin/zsh
#
# Update outdated base Python packages.

function print_updates() {
  # $1 - label for "no updates" message
  local had_output=false
  local package
  local old_version

  while IFS= read -r line; do
    if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
      echo "$line"
      had_output=true
    elif [[ "$line" =~ "^ - (.+)==(.+)$" ]]; then
      package="${match[1]}"
      old_version="${match[2]}"
    elif [[ "$line" =~ "^ \+ (.+)==(.+)$" ]] && [[ -n "$package" ]]; then
      echo "${match[1]} $old_version -> ${match[2]}"
      package=""
      had_output=true
    fi
  done
  [[ $had_output == false ]] && echo "No $1 updates"
}

function venv_update() {
  # $1 - venv name; $2 - path to req file
  printf "\nUpdate %s virtual environment:\n" $1
  print_updates "$1 package" < <(uv pip install \
    --python "$HOME/.local/pyvenvs/$1/bin/python" \
    --exact --upgrade --no-progress -r "$2/venv-pydata-reqs.in" 2>&1)
}

echo "Updating Python Packages..."
if (( $+commands[uv] )); then
  echo "Update Python apps:"
  print_updates "app" < <(uv tool upgrade --all \
    --no-progress --color never 2>&1)

  req_path=${0:a:h}
  venv_update pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi
