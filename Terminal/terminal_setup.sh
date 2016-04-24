#!/bin/bash

# Install powerline font for vim-airline plugin
fdir=~/Library/Fonts/ 
font="Sauce Code Powerline Regular.otf"
url=https://github.com/powerline/fonts/raw/master/SourceCodePro/Sauce%20Code%20Powerline%20Regular.otf

cd $fdir && { curl -L -o $font $url ; cd -; }
