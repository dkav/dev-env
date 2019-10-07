#!/bin/bash

# Summary: Update all outdated Python packages
#

pip3 list --outdated --format=columns | tail -n +3 \
            | cut -d ' ' -f 1 | xargs -n 1 pip3 install -U
