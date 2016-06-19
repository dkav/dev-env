#!/bin/sh -l
#
# Source - https://gist.github.com/othiym23/4ac31155da23962afd0e

# Summary: Updates outdated global packages
#
#
# Usage: npm_update.sh
#

set -e
set -x

# Activate Node Version Manager
nodev

for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
do
    npm -g install "$package"
done
