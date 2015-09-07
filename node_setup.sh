# Summary: Setup Node development environment#
#
# Usage: node_setup
#

# Install Node Version Manager
brew install nvm
mkdir /usr/local/var/nvm
cp $(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/

# Make stable release the default
. ~/.bash_profile
nvm alias default stable
