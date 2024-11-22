#!/bin/zsh
#
# Install base packages for Ruby development.

if [ -x "$(command -v $HOMEBREW_PREFIX/opt/ruby/bin/gem)" ]; then
  echo "Install Ruby Gems..."
  cd ${0:A:h} || return
  echo "Installing gems..."
  bundle install --gemfile Gemfile --quiet
else
  echo "Error: RubyGems is not installed" >&2
fi
