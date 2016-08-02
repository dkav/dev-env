#!/bin/bash

# Summary: Installs a selection of Node packages
#
#
# Usage: npm_packages
#

# Initialize Node Version Manager
. ~/.dev/dev_no

# Install global packages
npm install --global http-server topojson
