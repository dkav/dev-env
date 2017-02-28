#!/bin/bash

# Summary: Update non-default Ruby gems
#
# Usage: gem_update <Ruby version>
#

rb_ver=$1

if [ -z "$rb_ver" ]; then
    echo "Usage: rb_update <Ruby version>"
else
    # Setup rbenv environment
    . ~/.dev/dev_rb
    rbenv shell $rb_ver

    # Update gems
    if [ $? -eq 0 ]; then
        gem list | \
            cut -d' ' -f1  | \
            grep -Ev 'bigdecimal|io-console|json|openssl|psych|rdoc' | \
            xargs gem update
        gem cleanup
    fi
fi
