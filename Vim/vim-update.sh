#!/bin/zsh
#
# Update Vim plugins.

packdir=$HOME/.vim/pack

if [ ! -d $packdir ]; then
  echo "Error: Vim not installed" >&2
  return
fi

counter=0

update_vplugin()
{ # Function to clone Vim plugins

  # Input parameters
  local install_dir=$packdir/$1
  local gen_doc=$2
  local base_name=$(basename $install_dir)

  if [ -d $install_dir/.git ]; then
    # Get project from Github
    cd $install_dir
    git fetch --depth 1 --quiet

    head_hash=$(git rev-parse HEAD)
    upstream_hash=$(git rev-parse master@{upstream})

    if [ "$head_hash" != "$upstream_hash" ]; then
      echo "Updating $base_name"
      git reset --hard --quiet origin/master
      git clean -dfx  --quiet

      # Generate helptags
      if [ -z $gen_doc ] ; then
        mvim -nNes -u NONE -c "helptags $install_dir/doc" -c q
      fi
      let counter++
    fi
  else
    echo "Warning: $base_name not installed"
  fi
}

# Update
source ${0:a:h}/vplugins.sh
for plugin in $plugins; do
  update_vplugin ${${(P)plugin}[2]} ${${(P)plugin}[3]}
done

# Check that updates occurred
if [[ "$counter" -eq 0 ]]; then
  echo "No plugin updates"
fi
