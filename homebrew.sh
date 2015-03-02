# Script to install Homebrew and relevant packages #

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Create symbolic link to zsh shell completions
sudo ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/share/zsh/site-functions/_brew

# Install packages
brew install exiftool wget
