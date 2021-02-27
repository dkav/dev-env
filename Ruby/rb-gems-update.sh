#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/bundle)" ]; then
  echo "Updating Ruby Gems..."
  cd ${0:A:h}
  gem update --system --quiet | grep "Installing"
  gs_update=$?
  export GEM_PATH=$(gem environment gemdir)
  bundle update --all | grep "Installing"
  if [[  $gs_update != 0 && $? != 0  ]]; then
      echo "No gems to update"
  fi
  bundle clean --force
else
  echo "Error: bundle is not installed" >&2
fi
