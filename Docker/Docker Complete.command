#!/bin/zsh

# Summary: Setup shell completetion for Docker
#
# Usage: docker_complete

dockerdir="/Applications/Docker.app/Contents/Resources/etc"

# Zsh completions
cd /usr/local/share/zsh/site-functions
ln -sf $dockerdir/docker.zsh-completion _docker
ln -sf $dockerdir/docker-machine.zsh-completion _docker-machine
ln -sf $dockerdir/docker-compose.zsh-completion _docker-compose

read -s -k '?Press any key to continue...'
