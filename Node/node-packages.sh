#!/bin/zsh
#
# Installs a selection of Node packages.

# Install global packages
if [ -x "$(command -v npm)" ]; then
  echo "Installing Node packages..."
  sed '/#.*/d;/^$/d' ${0:a:h}/node-requirements.txt \
    | xargs npm install --global --no-fund --no-progress --quiet 1>/dev/null
else
  echo "Error: Node is not installed" >&2
fi
