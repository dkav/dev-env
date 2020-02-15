#!/bin/zsh
#
# Add symbolic link to mac-update script in /usr/local/bin.

source_dir=${0:a:h}

ln -s -f $source_dir/mac-update.sh   /usr/local/bin/mac-update
