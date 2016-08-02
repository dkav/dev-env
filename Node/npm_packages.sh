#!/bin/bash

# Summary: Installs a selection of Node packages
#
#
# Usage: npm_packages
#

# Initialize Node Version Manager
. ~/.bash_profile
nodev

# Install global packages
npm install --global http-server topojson
