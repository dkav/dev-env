#!/bin/zsh
#
# Install base packages for Python.

# Python 3
function venv_install() {
  # $1 - venv name; $2 - path to req file
  echo " $1"
  uv venv $HOME/.local/pyvenvs/$1 --quiet
  source $HOME/.local/pyvenvs/$1/bin/activate
  pip3 install --requirement $2/venv-$1-reqs.in --quiet
  python3 -m ipykernel install --user --name $1 --display-name "Python 3 ($1)"
  uv pip install --requirements $2/venv-$1-reqs.in --quiet
  uv run python3 -m ipykernel install --user --name $1 \
      --display-name "Python 3 ($1)"  > /dev/null
  deactivate
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/uv)" ]; then
  echo "Installing Python 3 packages..."

  # Linting tools
  echo " ruff"
  uv tool install ruff --quiet
  mkdir -p $XDG_DATA_HOME/zsh/site-functions/
  ruff generate-shell-completion zsh > $XDG_DATA_HOME/zsh/site-functions/_ruff

  echo " pylint"
  uv tool install pylint --with pylint-venv --quiet
  echo " pyright"
  uv tool install pyright
  echo " vulture"
  uv tool install vulture --quiet

  # IPython
  echo " ipython"
  uv tool install ipython --quiet

  # Jupyter
  echo " jupyter"
  uv tool install jupyter--core --with jupyter --quiet

  # Virtual environments
  printf "\nInstalling virtual environments...\n"
  req_path=${0:a:h}
  venv_install pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi

# Python 2
if [ -x "$(command -v $HOMEBREW_PREFIX/bin/mise)" ]; then
  printf "\nInstalling Python 2 packages...\n"

  mise install python@2.7.18
  mise alias set python py2 2.7.18
  mise exec python@2.7.18 -- python -m pip install ipykernel
  mise exec python@2.7.18 -- python -m ipykernel install --user
else
  printf "\nError: mise is not installed\n" >&2
fi

