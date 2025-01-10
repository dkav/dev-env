#!/bin/zsh
#
# Update outdated base Python packages.

function venv_update() {
  # $1 - venv name; $2 - path to req file
  printf "\nUpdate %s virtual environment\n" $1
  uvout="$(uv pip install --directory $HOME/.local/pyvenvs/$1 \
    --exact -U --no-progress -r $2/venv-pydata-reqs.in 2>&1 \
    | sed -E -n -e '/-|\+/,$p')"
   if [[ -n $uvout ]]; then
    echo $uvout
  else
    echo "No $1 libraries to update"
  fi
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/uv)" ]; then
  echo "Updating Python Packages..."
  echo "Update Python apps"
  uv tool upgrade --all --no-progress
  req_path=${0:a:h}
  venv_update pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi
