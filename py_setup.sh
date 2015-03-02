# Setup Python development environment

# Install Python 2.7
brew install pyenv pyenv-virtualenv
pyenv install 2.7.9
pyenv rehash

# Install Python 3.4
pyenv install 3.4.3
pyenv rehash
pyenv shell 3.4.3
pip install --upgrade setuptools
pyenv system
