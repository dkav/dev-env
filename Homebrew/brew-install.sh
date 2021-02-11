#!/bin/zsh
#
# Install Homebrew packages.

if ! (( ${+commands[brew]} )); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew bundle install --no-lock
else
  echo "Homebrew is installed"
fi
