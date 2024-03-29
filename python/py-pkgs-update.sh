#!/bin/zsh
#
# Update outdated base Python packages.

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pip3)" ]; then
  echo "Updating Python Packages..."
  export PIP_DISABLE_PIP_VERSION_CHECK=1
  export PYTHONWARNINGS="ignore:DEPRECATION"
  rpkgs=$(sed '/#.*/d;/^$/d;s/$/\ /' ${0:a:h}/py-requirements.txt)
  plst=$(pip3 list --outdated)
  opkgs=$(echo $plst | grep -E $rpkgs)
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
  echo "Error: pip is not installed" >&2
fi
