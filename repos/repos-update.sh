#!/bin/zsh
# Update all repositories (GitHub and Bitbucket)

repos-github sync -q
echo
repos-github fetch
echo
repos-push-bitbucket
