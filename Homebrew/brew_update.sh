#!/bin/zsh

# Update Homebrew and Homebrew packages #

brew update 1>/dev/null

echo "Updating packages"
brew outdated
brew upgrade 1>/dev/null

echo "Updating cask packages"
brew cask outdated
brew cask upgrade 1>/dev/null

echo "Cleaning up"
brew cleanup 1>/dev/null
