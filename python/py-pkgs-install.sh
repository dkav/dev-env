#!/bin/zsh
#
# Install base packages for Python.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Installing Python packages..."

  export USE_EMOJI=0

  # Linting tools
  pipx install ruff pylint vulture
  ruff generate-shell-completion zsh > $XDG_DATA_HOME/zsh/site-functions/_ruff

 # Jupyter
  pipx jupyterlab
  pipx inject jupyterlab jupyterlab-vim matplotlib pandas
else
  echo "Error: pipx is not installed" >&2
fi
