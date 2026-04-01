#!/bin/zsh
# Update all repositories (GitHub and Bitbucket)

repos-github sync -q
echo
repos-github pull
echo
repos-github push
echo
repos-push-bitbucket
