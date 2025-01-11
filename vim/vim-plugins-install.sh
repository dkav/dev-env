#!/bin/zsh
#
# Install Vim plugins.

dotdir=$XDG_CONFIG_HOME/vim
packdir=$dotdir/pack
sdir=${0:A:h}

# Make vim packdir in .vim folder
mkdir -p $packdir

clone_vplugin()
{ # Function to clone Vim plugins

  # Input parameters
  local repo=$1
  local install_dir=$packdir/$2
  local gen_doc=$3

  if [ ! -d "$install_dir"/.git ]; then
    echo "    $(basename $repo)"

    # Get project from Github
    git clone --depth 1 --quiet git@github.com:/$repo.git $install_dir

    # Generate helptags
    if ( $gen_doc ) ; then
      mvim -nNes -u NONE -i NONE -c "helptags $install_dir/doc" -c q
    fi
  else
    echo >&2 "    $(basename $repo) already installed"
  fi
}

# Clone
source $sdir/vplugins.sh

if [[ -n $1 ]]; then
  if [[ ${plugins[(ie)$1]} -le ${#plugins} ]]; then
    echo "Installing vim plugin..."
    clone_vplugin ${(P)1}
  else
    echo "Plugin not listed in vplugins.sh"
  fi
else
  echo "Installing vim plugins..."
  for plugin in $plugins; do
    clone_vplugin ${(P)plugin}&
  done
  wait

  # Install Powerline font
  if [[ ${plugins[(ie)airline]} -le ${#plugins} ]]; then
    echo
    source $sdir/vim-font.sh
  fi
fi
