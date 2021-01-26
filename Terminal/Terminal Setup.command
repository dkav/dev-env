#!/bin/zsh
#
# Setup Terminal.

# Change shell to zsh (assumes Homebrew zsh is intalled).
chsh -s `command -v zsh`

# Install powerline font for vim-airline plugin.
fdir=~/Library/Fonts/
font="Source Code Pro for Powerline.otf"
url=https://github.com/powerline/fonts/raw/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf

cd $fdir && { curl -L -o "$font" $url ; cd -; }

read -s -k '?Press any key to continue...'
