#!/bin/zsh
#
# Update all outdated Python packages.

if [ -x "$(command -v /usr/local/bin/pip3)" ]; then
  rpkgs=$(sed '/#.*/d;/^$/d;s/$/\ /' ${0:a:h}/py-requirements.txt)
  plst=$(pip3 list --outdated)
  opkgs=$(echo $plst | egrep $rpkgs)
  if [[ -n $opkgs ]]; then
    echo $plst | head -2
    echo $opkgs \
      | tee "$(tty)" \
      | cut -d ' ' -f 1 \
      | xargs pip3 install --upgrade --quiet
  else
    echo "No packages to update"
  fi
else
  echo "Error: Python is not installed" >&2
fi
