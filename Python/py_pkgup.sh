#!/bin/bash

# Summary: Update all Python packages
#
# Usage: py_pkgup <Python version>
#

py_version=$1

if [ -z "$py_version" ]; then
    echo "py_pkgup <Python version>"
else
    # Setup pyenv environment
    . ~/.bash_profile
    pydev

    # Update packages
    pyenv shell $py_version
    pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
    pyenv shell system
fi
