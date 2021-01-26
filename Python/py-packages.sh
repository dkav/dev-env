#!/bin/zsh
#
# Install base packages for Python development.

if [ -x "$(command -v /usr/local/bin/pip3)" ]; then
  echo "Installing Python packages..."
  pip3 install --requirement ${0:a:h}/py-requirements.txt --quiet
else
  echo "Error: Python is not installed" >&2
fi
