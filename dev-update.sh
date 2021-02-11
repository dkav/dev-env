#!/bin/zsh
#
# Update dev environment.

if [ "$#" -eq 0 ]; then
  in_args=( vim python ruby node )
else
  in_args=( "$@" )
fi

denv_dir=${0:A:h}

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
