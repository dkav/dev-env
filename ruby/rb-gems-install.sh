#!/bin/zsh
#
# Install base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  echo "Install Ruby Gems..."
  cd ${0:A:h} || return
  gem update --system --silent 1>/dev/null
  gem cleanup
  echo "Installing gems..."
  bundle install --gemfile Gemfile --quiet
else
  echo "Error: gem is not installed" >&2
fi
