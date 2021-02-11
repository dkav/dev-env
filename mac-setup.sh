#!/bin/zsh
#
# Setup macOS environment.

if [ "$#" -eq 0 ]; then
  in_args=( brew vim python ruby node )
else
  in_args=( "$@" )
fi

denv_dir=${0:A:h}

# Homebrew
if (($in_args[(Ie)brew])); then
  echo "Setup Homebrew..."
  "$denv_dir/Homebrew/brew-install.sh"
fi

# Vim
if (($in_args[(Ie)vim])); then
  echo "\nSetup Vim ..."
  "$denv_dir/vim/vim-setup.sh"
fi

# Python
if (($in_args[(Ie)python])); then
  echo "\nSetup Python Packages..."
  "$denv_dir/Python/py-packages.sh"
fi

# Ruby
if (($in_args[(Ie)ruby])); then
  echo "\nSetup Ruby Gems..."
  "$denv_dir/Ruby/rb-packages.sh"
fi

# Node
if (($in_args[(Ie)node])); then
  echo "\nSetup Node Packages..."
  "$denv_dir/Node/node-packages.sh"
fi

# Create link to mac-update script
ln -s -f $denv_dir/mac-update.sh /usr/local/bin/mac-update
