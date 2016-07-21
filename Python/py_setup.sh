#!/bin/bash

# Summary: Setup Python development environment
#
# Usage: py_setup <Python version> [<Python version>]
#

if [ -z "$1" ]; then
    echo "Usage: py_setup <Python version> [<Python version>]"
else
    # Setup pyenv environment
    . ~/.bash_profile
    pydev

    # Install Python
    for py_version in "$@"
    do
        pyenv install $py_version
        pyenv rehash
        pyenv shell $py_version
        pip install --upgrade pip
    done
fi
