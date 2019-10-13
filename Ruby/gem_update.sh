#!/bin/zsh

# Summary: Update base packages for Ruby development

gem update --system
gem update bundler github-pages
gem cleanup
