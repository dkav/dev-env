#!/bin/zsh
#
# Install Vim plugins.

echo >&2 "  installing vim plugins:"

dotdir=$HOME/.vim
packdir=$dotdir/pack

# Make vim packdir in .vim folder
mkdir -p $packdir

clone_vplugin()
{ # Function to clone Vim plugins

  # Input parameters
  local repo=$1
  local install_dir=$packdir/$2
  local gen_doc=$3

  echo >&2 "    $(basename $repo)"

  # Get project from Github
  git clone --depth 1 --quiet git@github.com:/$repo.git $install_dir

  # Generate helptags
  if ( $gen_doc ) ; then
    mvim -nNes -u NONE -c "helptags $install_dir/doc" -c q
  fi
}

# Clone
source ${0:a:h}/vplugins.sh
for plugin in $plugins; do
  clone_vplugin ${(P)plugin}
done
