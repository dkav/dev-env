#!/bin/bash

# Summary: Setup Python development environment
#
# Usage: py_setup <Python version> [<Python version>]
#

if [ -z "$1" ]; then
    echo "Usage: py_setup <Python version> [<Python version>]"
else
    # Install Python
    . ~/.bash_profile
    pydev

    for py_version in "$@"
    do
        pyenv install $py_version
    done
    pyenv rehash
fi
