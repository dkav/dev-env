#!/bin/zsh

# Summary: Update base packages for Ruby development

gem update --system --quiet 1>/dev/null
gem outdated | egrep "bundler|github-pages" \
	&& gem update --quiet bundler github-pages 1>/dev/null
gem cleanup --quiet 1>/dev/null
