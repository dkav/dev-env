#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v $HOMEBREW_PREFIX/opt/ruby/bin/bundle)" ]; then
  echo "Updating Ruby Gems..."
  cd ${0:A:h} || return
  gem update --system --quiet | grep "Installing"
  gs_update=$?
  GEM_PATH=$(gem environment gemdir)
  export GEM_PATH
  bundle update --bundler | grep "Installing"
  gb_update=$?
  bundle update --all | grep "Installing"
  ga_update=$?
  if [[  $gs_update != 0 && $ga_update != 0 && $gb_update != 0  ]]; then
      echo "No gems to update"
  fi
  bundle clean --force 1>/dev/null
else
  echo "Error: bundle is not installed" >&2
fi
