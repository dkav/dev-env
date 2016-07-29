#!/bin/bash

# Summary: Setup Jupyter virutal environment
#
# Usage: py_jupyter <Python version>
#

py_version=$1  # Python version to use

if [ -z "$py_version" ]; then
    echo "Usage: py_jupyter <Python version>"
else
    # Setup pyenv environment
    . ~/.bash_profile
    pydev

    # Setup jupyter
    if pyenv virtualenv $py_version jupyter; then
        pyenv rehash

        pyenv shell jupyter

        pip install --upgrade setuptools pip
        pip install jupyter
        brew install freetype
        pip install matplotlib
        pip install pandas
        pip install rpy2 # R needs to be installed
    else
        exit 1
    fi
fi
