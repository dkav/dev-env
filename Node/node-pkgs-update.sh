#!/bin/zsh
#
# Update outdated global npm packages.
#
# Original source -
# https://gist.github.com/othiym23/4ac31155da23962afd0e

if [ -x "$(command -v npm)" ]; then
  echo "Updating Node Packages..."
  no=($(sed '/#.*/d;/^$/d' ${0:a:h}/node-requirements.txt \
      | xargs npm outdated --global --parseable --depth=0 --quiet \
      | cut -d: -f3,4))
  if [[ -n $no ]]; then
    for package in $no; do
      npkg="$(cut -d: -f2 <<<"$package")"
      cver="$(cut -d@ -f2 <<<"$(cut -d: -f1 <<<"$package")")"
      pver="$(cut -d@ -f2 <<<"$npkg")"
      pkg="$(cut -d@ -f1 <<<"$npkg")"
      echo $npkg
      echo "Updating $pkg ($cver-->$pver)"
      npm install --global --no-fund --no-progress --quiet $npkg 1>/dev/null
    done
  else
    echo "No packages to update"
  fi
else
  echo "Error: npm is not installed" >&2
fi
