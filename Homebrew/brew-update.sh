#!/bin/zsh
#
# Update Homebrew packages.

brew update 1>/dev/null

bo=$(brew outdated --verbose)
if [[ -n $bo ]]; then
  echo "Updating packages"
  echo $bo
  brew upgrade 1>/dev/null
else
  echo "No packages to update"
fi
