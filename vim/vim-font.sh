#!/bin/zsh
#
# Install Powerline font for vim-airline plugin.

echo "Installing Powerline font for vim-airline"

fdir=~/Library/Fonts/
font="Source Code Pro for Powerline.otf"
url=https://raw.githubusercontent.com/powerline/fonts/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf

cd $fdir || exit && { curl -L -S -s -o "$font" $url ; cd - || exit; }
