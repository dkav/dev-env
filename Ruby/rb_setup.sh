#!/bin/bash

# Summary: Setup Ruby virtual environment
#
# Usage: rb_setup <Ruby version to install> [<Ruby version to remove>]
#

rb_new=$1
rb_old=$2

if [ -z "$rb_new" ]; then
    echo "Usage: rb_setup <Ruby version to install> [<Ruby version to remove>]"
else
    # Setup rbenv environment
    . ~/.bash_profile
    rbdev

    # Install new Ruby version
    rbenv install $ruby_new
    rbenv rehash
    rbenv shell $ruby_new
    gem install bundler

    # Optional removal of old Ruby version
    if [ ! -z "$rb_old" ]; then
        rbenv uninstall $rb_old
    fi
    rbenv rehash
fi
