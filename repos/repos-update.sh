#!/bin/zsh

# Update all repositories (GitHub and Bitbucket).

repos-github sync -q

echo
repos-github pull

echo
host-wktrees-rebase

echo
repos-push-ssd

echo
repos-push-bitbucket
