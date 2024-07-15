#!/bin/zsh
#
# Install base packages for Python.

function venv_install() {
  # $1 - venv name; $2 - path to req file
  printf "\nInstall %s virtual environment\n" $1
  export PIP_DISABLE_PIP_VERSION_CHECK=1
  python3 -m venv $HOME/.local/pyvenvs/$1
  source $HOME/.local/pyvenvs/$1/bin/activate
  pip3 install --requirement $2/venv-$1-reqs.txt --quiet
  deactivate
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Installing Python packages..."

  export USE_EMOJI=0

  # Linting tools
  pipx install ruff pylint vulture
  pipx inject pylint pylint-venv
  mkdir -p $XDG_DATA_HOME/zsh/site-functions/
  ruff generate-shell-completion zsh > $XDG_DATA_HOME/zsh/site-functions/_ruff

  # Jupyter
  pipx install ipython jupyterlab

  # Virtual environments
  req_path=${0:a:h}
  venv_install pydata $req_path
else
  echo "Error: pipx is not installed" >&2
fi
