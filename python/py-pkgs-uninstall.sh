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


# Python 2
if [ -x "$(command -v $HOMEBREW_PREFIX/bin/mise)" ]; then
  echo "Uninstalling Python 2 packages..."
  mise alias unset python py2
  jupyter kernelspec remove -f python2
  mise uninstall python@2.7.18
else
  echo "Error: mise is not installed" >&2
fi
