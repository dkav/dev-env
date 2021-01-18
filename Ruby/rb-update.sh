#!/bin/zsh
#
# Update base packages for Ruby development.

if [ -x "$(command -v /usr/local/opt/ruby/bin/gem)" ]; then
  gem update --system --quiet 1>/dev/null
  gems=$(sed '/#.*/d;/^$/d;s/$/\ /' ${0:a:h}/rb-requirements.txt)
  gemso=$(gem outdated | egrep $gems)
  if [[ -n $gemso ]]; then
    echo $gemso \
      | tee "$(tty)" \
      | cut -d ' ' -f 1 \
      | xargs gem update 1>/dev/null
    echo "Cleaning up"
    gem cleanup --quiet 1>/dev/null
  else
    echo "No gem updates"
  fi
else
  echo "Error: Ruby is not installed" >&2
fi
