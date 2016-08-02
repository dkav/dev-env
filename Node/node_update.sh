#!/bin/bash

# Summary: Removes older Node release and installs latest stable version
#
# Usage: node_update
#

# Initialize Node Version Manager
. ~/.bash_profile
nodev

# Install latest release
cnode="$(nvm version node)"
nvm install node --reinstall-packages-from=node

# Uninstall previous version if upgraded
nnode="$(nvm version node)"
if [ "$cnode" != "$nnode" ]; then
    nvm use node
    nvm uninstall $cnode
fi
