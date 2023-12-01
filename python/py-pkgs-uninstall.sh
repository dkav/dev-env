#!/bin/zsh
#
# Uninstall all pip packages.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pip3)" ]; then
  echo "Uninstalling Python packages..."
  export PIP_DISABLE_PIP_VERSION_CHECK=1
  pip3 freeze | xargs pip3 uninstall --yes --quiet
else
  echo "Error: pip is not installed" >&2
fi
