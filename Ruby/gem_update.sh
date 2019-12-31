#!/bin/zsh

# Summary: Update base packages for Ruby development

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
    gem update --system --quiet 1>/dev/null
    gem outdated | egrep "bundler|github-pages" \
        && gem update --quiet bundler github-pages 1>/dev/null
    gem cleanup --quiet 1>/dev/null
else
    "Error: Ruby is not installed" >&2
fi
