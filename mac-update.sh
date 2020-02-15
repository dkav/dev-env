#!/bin/zsh
#
# Update macOS environment.

denv_dir=${"$(readlink $0)":a:h}

# Homebrew
echo "Updating Homebrew..."
"$denv_dir/Homebrew/brew-update.sh"

# Vim
echo "\nUpdating Vim Plugins..."
"$denv_dir/vim/vim-update.sh"

# Python
echo "\nUpdating Python Packages..."
"$denv_dir/Python/pip-update.sh"

# Ruby
echo "\nUpdating Ruby Gems..."
"$denv_dir/Ruby/gem-update.sh"

# Node
echo "\nUpdating Node Packages..."
"$denv_dir/Node/npm-update.sh"
