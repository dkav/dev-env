#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  echo "Updating Ruby Gems..."
  cd ${0:A:h}
  gem update --system --quiet 1>/dev/null
  if [ -x "$(command -v /usr/local/opt/ruby/bin/bundle)" ]; then
    export GEM_PATH=$(gem environment gemdir)
    bundle update --all | grep "Installing"
    if [[ $? != 0 ]]; then
      echo "No gems updated"
    fi
    bundle clean --force
  else
    echo "Error: bundle is not installed" >&2
  fi
else
  echo "Error: gem is not installed" >&2
fi
