# Summary: Setup Node development environment#
#
# Usage: node_setup
#

# Install Node Version Manager
brew install nvm
mkdir /usr/local/var/nvm
cp $(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/

# Install stable release and make it the default
. ~/.bash_profile
nodev
nvm install stable
