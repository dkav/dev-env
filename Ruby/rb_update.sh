#!/bin/bash

# Summary: Update Ruby virtual environment
#
# Usage: rb_update <Ruby version to install> [<Ruby version to remove>]
#

rb_new_ver=$1
rb_old_ver=$2

if [ -z "$rb_new_ver" ]; then
    echo "Usage: rb_update <Ruby version to install> [<Ruby version to remove>]"
else
    . ~/.bash_profile
    rbdev
    rbenv install $rb_new_ver
    if [ ! -z "$rb_old_ver" ]; then
        rbenv uninstall $rb_old_ver
    fi
    rbenv rehash
fi
