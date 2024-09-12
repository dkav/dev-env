#!/bin/zsh
#
# Uninstall Vim plugins.

packdir=$XDG_CONFIG_HOME/vim/pack

if [[ -n $1 ]]; then
  source ${0:A:h}/vplugins.sh
  if [[ ${plugins[(ie)$1]} -le ${#plugins} ]]; then
    echo "Removing vim plugin $1"
    rm -frd ${packdir:?}/${${(P)1}[2]}
  else
    echo "Plugin not listed in vplugins.sh"
  fi
else
  echo "Removing vim plugins"
  rm -frd $packdir
fi
