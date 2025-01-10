#!/bin/zsh
#
# Install base packages for Python.

# Python 3
function venv_install() {
  # $1 - venv name; $2 - path to req file
  printf "\nInstall %s virtual environment\n" $1
  export PIP_DISABLE_PIP_VERSION_CHECK=1
  python3 -m venv $HOME/.local/pyvenvs/$1
  source $HOME/.local/pyvenvs/$1/bin/activate
  pip3 install --requirement $2/venv-$1-reqs.in --quiet
  python3 -m ipykernel install --user --name $1 --display-name "Python 3 ($1)"
  deactivate
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Installing Python 3 packages..."

  export USE_EMOJI=0

  # Linting tools
  pipx install ruff pylint vulture
  pipx inject pylint pylint-venv
  mkdir -p $XDG_DATA_HOME/zsh/site-functions/
  ruff generate-shell-completion zsh > $XDG_DATA_HOME/zsh/site-functions/_ruff

  # Jupyter
  pipx install jupyter --include-deps

  # Virtual environments
  req_path=${0:a:h}
  venv_install pydata $req_path
else
  echo "Error: pipx is not installed" >&2
fi

# Python 2
if [ -x "$(command -v $HOMEBREW_PREFIX/bin/mise)" ]; then
  echo "Installing Python 2 packages..."

  mise install python@2.7.18
  mise alias set python py2 2.7.18
  mise exec python@2.7.18 -- python -m pip install ipykernel
  mise exec python@2.7.18 -- python -m ipykernel install --user
else
  echo "Error: mise is not installed" >&2
fi

