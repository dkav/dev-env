#!/bin/zsh
#
# Setup shell completetion for Docker.

docker_dir="/Applications/Docker.app/Contents/Resources/etc"

# Zsh completions
cd /usr/local/share/zsh/site-functions
ln -sf $docker_dir/docker.zsh-completion _docker
ln -sf $docker_dir/docker-machine.zsh-completion _docker-machine
ln -sf $docker_dir/docker-compose.zsh-completion _docker-compose

read -s -k '?Press any key to continue...'
