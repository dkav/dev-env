#!/bin/bash

# Summary: Setup Python development environment
#
# Usage: py_setup <Python version> [<Python version>]
#

if [ -z "$1" ]; then
    echo "Usage: py_setup <Python version> [<Python version>]"
else
    # Setup pyenv environment
    . ~/.dev/dev_py

    # Install Python
    for py_version in "$@"
    do
        pyenv install $py_version
         if [ $? -eq 0 ]; then
            pyenv rehash
            pyenv shell $py_version
            pip install --upgrade setuptools pip
        fi
    done
fi
