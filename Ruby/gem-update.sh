#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  gem update --system --quiet 1>/dev/null
  if ( gem outdated | egrep "bundler|github-pages" ); then
    gem update --quiet bundler github-pages 1>/dev/null
    echo "Cleaning up"
    gem cleanup --quiet 1>/dev/null
  else
    echo "No bundler or github-pages updates"
  fi
else
  "Error: Ruby is not installed" >&2
fi
