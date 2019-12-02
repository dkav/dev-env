#!/bin/zsh
#
# Original source -
# https://gist.github.com/othiym23/4ac31155da23962afd0e

# Summary: Updates outdated global packages
#

npm --global outdated --depth=0
for package in $(npm --global outdated --parseable --depth=0 | cut -d: -f4)
do
    echo
    npm install --global --no-progress --silent $package
done
