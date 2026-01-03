#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v $HOMEBREW_PREFIX/opt/ruby/bin/bundle)" ]; then
  echo "Updating Ruby Gems..."
  cd ${0:A:h} || return
  bundle update --all | grep "Installing"
  ga_update=$?
  if [[  $ga_update != 0  ]]; then
      echo "No gems to update"
  fi
  bundle clean --force 1>/dev/null
else
  echo "Error: Bundler is not installed" >&2
fi
