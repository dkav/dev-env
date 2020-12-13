#!/bin/zsh
#
# Setup macOS environment.

denv_dir=${"$(readlink $0)":a:h}

# Homebrew
echo "Setup Homebrew..."
"$denv_dir/Homebrew/brew-install.sh"

# Vim
echo "\nSetup Vim ..."
"$denv_dir/vim/vim-setup.sh"
"$denv_dir/vim/MacVim Install.command"

# Python
echo "\nSetup Python Packages..."
"$denv_dir/Python/py-dev.sh"
"$denv_dir/Python/py-jupyter.sh"

# Ruby
echo "\nSetup Ruby Gems..."
"$denv_dir/Ruby/rb-dev.sh"

# Node
echo "\nSetup Node Packages..."
"$denv_dir/Node/npm-packages.sh"
