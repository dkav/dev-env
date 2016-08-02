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
    . ~/.dev/dev_py

    # Check if version exits
    if pyenv versions --bare | grep -q -x $py_version; then
        # Update packages
        pyenv shell $py_version
        pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
    else
        echo "Version $py_version is not installed"
    fi
fi
