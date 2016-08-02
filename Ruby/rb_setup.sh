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
    . ~/.dev/dev_rb

    # Install new Ruby version
    rbenv install $rb_new
    if [ $? -eq 0 ]; then
        rbenv rehash
        rbenv shell $rb_new
        gem install bundler

        # Optional removal of old Ruby version
        if [ ! -z "$rb_old" ]; then
            rbenv uninstall $rb_old
        fi
        rbenv rehash
    fi
fi
