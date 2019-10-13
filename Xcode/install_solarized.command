#!/bin/zsh

# Install Solarized Dark Theme for Xcode  #
#=========================================#
echo "Installing Solarized Theme"

DESTDIR=~/Library/Developer/Xcode/UserData/FontAndColorThemes/
mkdir -p $DESTDIR

curl -o "$DESTDIR/Solarized Dark.dvtcolortheme" https://raw.githubusercontent.com/ArtSabintsev/Solarized-Dark-for-Xcode/master/Solarized_Dark_by_ArtSabintsev.dvtcolortheme
