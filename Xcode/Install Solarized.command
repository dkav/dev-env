#!/bin/zsh

# Install Solarized Dark Theme for Xcode  #
#=========================================#
echo "Installing Solarized Theme"

destdir=~/Library/Developer/Xcode/UserData/FontAndColorThemes/
mkdir -p $destdir

curl -o "$destdir/Solarized Dark.dvtcolortheme" https://raw.githubusercontent.com/ArtSabintsev/Solarized-Dark-for-Xcode/master/Solarized_Dark_by_ArtSabintsev.dvtcolortheme

read -s -k '?Press any key to continue...'
