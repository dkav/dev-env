#!/bin/zsh
#
# Install Homebrew packages.

if ! [[ $+commands[brew] ]]; then
	@echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle install --no-lock
fi
