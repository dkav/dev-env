#!/bin/zsh
#
# Update outdated base Python packages.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Updating Python Packages..."
  export USE_EMOJI=0
  pipx upgrade-all --include-injected 
else
  echo "Error: pipx is not installed" >&2
fi
