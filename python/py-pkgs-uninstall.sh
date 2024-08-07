#!/bin/zsh
#
# Uninstall all pip packages.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Uninstalling Python packages..."
  export USE_EMOJI=0
  pipx uninstall-all

  # Virtual environments
  pyvenvs=$HOME/.local/pyvenvs
  if [ -d $pyvenvs ]; then
    rm -rf $pyvenvs
    echo "Removed Python virtual environments"
  fi
else
  echo "Error: pipx is not installed" >&2
fi
