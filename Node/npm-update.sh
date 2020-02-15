#!/bin/zsh
#
# Updates outdated global packages.
#
# Original source -
# https://gist.github.com/othiym23/4ac31155da23962afd0e

if [ -x "$(command -v npm)" ]; then
  no=($(npm --global outdated --parseable --depth=0 | cut -d: -f3,4))
  if [[ -n $no ]]; then
    for package in $no; do
      npkg="$(cut -d: -f2 <<<"$package")"
      cver="$(cut -d@ -f2 <<<"$(cut -d: -f1 <<<"$package")")"
      pver="$(cut -d@ -f2 <<<"$npkg")"
      pkg="$(cut -d@ -f1 <<<"$npkg")"
      echo "Updating $pkg ($cver-->$pver)"
      if [[ $npkg =~ "^npm@" ]]; then
        npm install --force --global --no-progress --quiet \
          $npkg 1>/dev/null
      else
        npm install --global --no-progress --quiet $npkg 1>/dev/null
      fi
    done
  else
    echo "No packages to update"
  fi
else
  echo "Error: Node is not installed" >&2
fi
