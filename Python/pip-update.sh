#!/bin/zsh
#
# Update all outdated Python packages.

if [ -x "$(command -v pip3)" ]; then
  po=$(pip3 list --outdated)
  if [[ -n $po ]]; then
    echo $po \
      | tee "$(tty)" \
      | tail -n +3 \
      | cut -d ' ' -f 1 \
      | xargs -n 1 pip3 install --upgrade --quiet
  else
    echo "No packages to update"
  fi
else
  echo "Error: Python is not installed" >&2
fi
