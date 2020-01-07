#!/bin/zsh

# Update Homebrew and Homebrew packages #

brew update 1>/dev/null

bo=$(brew outdated --verbose)
if [[ -n $bo ]]; then
    echo "Updating packages"
    echo $bo
    brew upgrade 1>/dev/null
fi

bko=$(brew cask outdated --verbose)
if [[ -n $bko ]]; then
    echo "Updating cask packages"
    echo $bko
    brew cask upgrade 1>/dev/null
fi

if [[ -n $bo || -n $bko ]]; then
    echo "Cleaning up"
    brew cleanup 1>/dev/null
else
    echo "No packages to update"
fi
