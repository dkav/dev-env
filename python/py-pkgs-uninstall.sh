#!/bin/zsh
#
# Uninstall all Python packages.

# Python 3

# Virtual environments
pyvenvs=$HOME/.local/pyvenvs
if [ -d $pyvenvs ]; then
  jupyter kernelspec remove -f pydata
  rm -rf $pyvenvs
  echo "Removed Python virtual environments"
fi

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/uv)" ]; then
  echo "Uninstalling Python 3 packages..."
  uv tool uninstall --all --quiet
else
  echo "Error: uv is not installed" >&2
fi
