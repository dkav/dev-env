# Setup Python development environment #

# Setup Python virtual environment
brew install pyenv pyenv-virtualenv pyenv-pip-migrate

# Install Python 2.7
pyenv install 2.7.9
pyenv rehash

# Install Python 3.x
pyenv install 3.4.3
pyenv rehash
pyenv shell 3.4.3
pip install --upgrade setuptools
pyenv system

