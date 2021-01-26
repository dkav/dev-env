#!/bin/zsh
#
# Install base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  echo "Updating the RubyGems system software"
  gem update --system --silent
  echo "Installing gems..."
  sed '/#.*/d;/^$/d;s/$/\ /' ${0:a:h}/rb-requirements.txt \
    | xargs gem install --silent
  echo "Cleaning up"
  gem cleanup --quiet 1>/dev/null 
else
  echo "Error: Ruby is not installed" >&2
fi
