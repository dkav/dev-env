#!/bin/zsh
#
# Update all outdated Python packages.

if [ -x "$(command -v /usr/local/bin/pip3)" ]; then
  po=$(pip3 list --outdated --not-required)
  if [[ -n $po ]]; then
    echo $po \
      | tee "$(tty)" \
      | tail -n +3 \
      | cut -d ' ' -f 1 \
      | xargs pip3 install --upgrade --upgrade-strategy eager --quiet
  else
    echo "No packages to update"
  fi
else
  echo "Error: Python is not installed" >&2
fi
