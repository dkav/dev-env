#!/bin/bash

# Summary: Removes older Node release and installs latest stable version
#
# Usage: node_update
#

# Activate Node Version Manager
. ~/.bash_profile
nodev

# Install latest release
nvm deactivate
nvm uninstall default
nvm install stable
