#!/bin/bash -l

# Summary: Removes older Node release and installs latest stable version
#
# Usage: node_update
#

# Activate Node Version Manager
nodev

# Install latest release
nvm deactivate
nvm uninstall default
nvm install node
