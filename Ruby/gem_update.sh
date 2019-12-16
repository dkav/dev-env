#!/bin/zsh

# Summary: Update base packages for Ruby development
gem update --system --silent
gem outdated | egrep "bundler|github-pages" \
	&& gem update --silent bundler github-pages
gem cleanup --silent
