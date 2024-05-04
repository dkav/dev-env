#!/bin/zsh
#
# Uninstall all pip packages.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Uninstalling Python packages..."
  export USE_EMOJI=0
  pipx unininstall-all
else
  echo "Error: pipx is not installed" >&2
fi
