# Summary: Setup iPython virutal environment
#
# Usage: py_ipython <Python version>
#

py_version=$1  # Python version to use

if [ -z "$py_version" ]; then
    echo "Usage: py_ipython <Python version>"
else
   . ~/.bash_profile
    pydev

    pyenv virtualenv $py_version ipython
    pyenv rehash

    pyenv shell ipython

    pip install jupyter
    brew install freetype
    pip install matplotlib
    pip install rpy2 # R needs to be installed

    pyenv shell system
fi
