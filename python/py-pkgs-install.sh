#!/bin/zsh
#
# Install base packages for Python.

if [ -x "$(command -v /usr/local/opt/python@3.10/bin/pip3)" ]; then
  echo "Installing Python packages..."
  pip3 install --requirement ${0:a:h}/py-requirements.txt --quiet
else
  echo "Error: pip is not installed" >&2
fi
