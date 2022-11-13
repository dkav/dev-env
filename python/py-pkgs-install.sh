#!/bin/zsh
#
# Install base packages for Python.

if [ -x "$(command -v /usr/local/bin/pip3)" ]; then
  echo "Installing Python packages..."
  pip3 install --requirement ${0:a:h}/py-requirements.txt --disable-pip-version-check --quiet
else
  echo "Error: pip is not installed" >&2
fi
