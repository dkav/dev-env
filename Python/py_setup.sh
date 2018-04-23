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
        CFLAGS="-I$(brew --prefix openssl)/include" \
        LDFLAGS="-L$(brew --prefix openssl)/lib" \
        pyenv install $py_version

         if [ $? -eq 0 ]; then
            pyenv rehash
            pyenv shell $py_version
            pip install --upgrade setuptools pip
            pip install ipython
            pip install flake8 flake8_docstrings pep8-naming pylint vulture
        fi
    done
fi
