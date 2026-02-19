#!/bin/zsh
#
# Update Miniforge.

if (( $+commands[mamba] )); then
  echo "Updating Miniforge..."
  output=$(mamba update -n base -c conda-forge -y -q conda mamba \
    | grep -E "Upgrade: [0-9]{1,} packages")
  if [ -z "$output" ]; then
    echo "Nothing to update"
  else
    echo $output
  fi
else
  echo "Error: mamba is not installed" >&2
fi
