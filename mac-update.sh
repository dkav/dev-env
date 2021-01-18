#!/bin/zsh
#
# Update macOS environment.

if [ "$#" -eq 0 ]; then
  in_args=( brew vim python ruby node )
else
  in_args=( "$@" )
fi

denv_dir=${0:A:h}

# Homebrew
if (($in_args[(Ie)brew])); then
  echo "Updating Homebrew..."
  "$denv_dir/Homebrew/brew-update.sh"
fi

# Vim
if (($in_args[(Ie)vim])); then
  echo "\nUpdating Vim Plugins..."
  "$denv_dir/vim/vim-update.sh"
fi

# Python
if (($in_args[(Ie)python])); then
  echo "\nUpdating Python Packages..."
  "$denv_dir/Python/py-update.sh"
fi

# Ruby
if (($in_args[(Ie)ruby])); then
  echo "\nUpdating Ruby Gems..."
  "$denv_dir/Ruby/rb-update.sh"
fi

# Node
if (($in_args[(Ie)node])); then
  echo "\nUpdating Node Packages..."
  "$denv_dir/Node/node-update.sh"
fi
