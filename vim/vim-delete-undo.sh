#!/bin/zsh
# Delete Vim undo files older than 90 days
/usr/bin/find ~/.local/state/vim/undo -type f -mtime +90 -delete -print
