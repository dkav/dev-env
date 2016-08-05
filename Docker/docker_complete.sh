#!/bin/bash

# Summary: Setup shell completetion for Docker
#
# Usage: docker_complete

# Bash completions
dockerdir="/Applications/Docker.app/Contents/Resources/etc"
cd /usr/local/etc/bash_completion.d
ln -s $dockerdir/docker.bash-completion
ln -s $dockerdir/docker-machine.bash-completion
ln -s $dockerdir/docker-compose.bash-completion

# Zsh completions
zshdir="/usr/local/share/zsh/site-functions"
curl -fLo $zshdir/_docker https://github.com/docker/docker/raw/master/contrib/completion/zsh/_docker

curl -L https://raw.githubusercontent.com/docker/machine/v$(docker-machine --version | tr -ds ',' ' ' | awk 'NR==1{print $(3)}')/contrib/completion/zsh/_docker-machine > $zshdir/_docker-machine

curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/zsh/_docker-compose > $zshdir/_docker-compose
