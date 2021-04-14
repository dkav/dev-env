#!/bin/zsh
#
# Uninstall all packages for Ruby.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  echo "Uninstalling gems..."
  export GEM_PATH=$(gem environment gemdir)
  gem uninstall --all --ignore-dependencies --executables --silent
else
  echo "Error:  gem is not installed" >&2
fi
