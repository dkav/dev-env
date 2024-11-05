#!/bin/zsh
#
# Uninstall all Python packages.

# Python 3
if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Uninstalling Python 3 packages..."
  export USE_EMOJI=0
  pipx uninstall-all

  # Virtual environments
  pyvenvs=$HOME/.local/pyvenvs
  if [ -d $pyvenvs ]; then
    jupyter kernelspec remove -f pydata
    rm -rf $pyvenvs
    echo "Removed Python virtual environments"
  fi
else
  echo "Error: pipx is not installed" >&2
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
