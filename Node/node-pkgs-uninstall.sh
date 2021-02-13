#!/bin/zsh
#
# Uninstall all global npm packages.

if [ -x "$(command -v npm)" ]; then
  echo "Uninstalling Node packages..."
  npm ls --global --parseable  --depth=0 \
    | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' \
    | xargs npm uninstall --global --no-progress --quiet 1>/dev/null
else
  echo "Error: npm is not installed" >&2
fi
