#!/bin/zsh
#
# Install base packages for Python.

# Python 3
function venv_install() {
  # $1 - venv name; $2 - path to req file
  echo " $1"
  uv venv $HOME/.local/pyvenvs/$1 --quiet --clear || return 1

  uv pip install --python "$HOME/.local/pyvenvs/$1/bin/python" \
    --quiet --requirements "$2/venv-$1-reqs.in"

  "$HOME/.local/pyvenvs/$1/bin/python" -m ipykernel install \
    --user --name $1 --display-name "Python 3 ($1)" > /dev/null
}

if (( $+commands[uv] )); then
  echo "Installing Python 3 packages..."

  # Linting tools
  echo " ruff"
  uv tool install ruff --quiet
  data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  mkdir -p $data_home/zsh/site-functions/
  ruff generate-shell-completion zsh > $data_home/zsh/site-functions/_ruff

  echo " pylint"
  uv tool install pylint --with pylint-venv --quiet
  echo " pyright"
  uv tool install pyright --quiet
  echo " vulture"
  uv tool install vulture --quiet

  # IPython
  echo " ipython"
  uv tool install ipython --quiet

  # Jupyter
  echo " jupyter"
  uv tool install jupyter-core --with jupyter --quiet

  # Virtual environments
  printf "\nInstalling virtual environments...\n"
  req_path=${0:a:h}
  venv_install pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi
