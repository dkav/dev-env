# Summary: Setup Python development environment
#
# Usage: py_setup <Python version> [<Python version>]
#

if [ -z "$1" ]; then
    echo "Usage: py_setup <Python version> [<Python version>]"
else
    # Setup Python virtual environment
    brew install pyenv pyenv-virtualenv pyenv-pip-migrate

    # Install Python
    . ~/.bash_profile
    pydev

    for py_version in "$@"
    do
        CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix openssl)/lib" CPPFLAGS="-I$(brew --prefix openssl)/include pyenv install $py_version
    done
    pyenv rehash
fi
