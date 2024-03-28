#!/bin/zsh
#
# Update Vim plugins.

echo "Updating vim plugins..."

packdir=$HOME/.vim/pack

if [ ! -d "$packdir" ]; then
  echo "Error: Vim not installed" >&2
  return
fi

counter=0

update_vplugin()
{ # Function to clone Vim plugins

  # Input parameters
  local install_dir=$packdir/$1
  local gen_doc=$2
  local base_name

  base_name=$(basename "$install_dir")

  if [ -d "$install_dir"/.git ]; then
    # Get project from Github
    cd "$install_dir" || return
    git fetch --depth 1 --quiet
    def_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    head_hash=$(git rev-parse --quiet --verify --short "$def_branch")
    upstream_hash=$(git rev-parse --quiet --verify --short "$def_branch@{upstream}")

    if [ "$head_hash" != "$upstream_hash" ]; then
      printf "\rUpdating %s (%s --> %s)\033[0K\n" \
        $base_name $head_hash $upstream_hash
      git reset --hard --quiet origin/"$def_branch"
      git clean -dfx --quiet

      # Generate helptags
      if ( $gen_doc ) ; then
        mvim -nNes -u NONE -c "helptags $install_dir/doc" -c q
      fi
     (( counter++ ))
    fi
  else
    printf "\rWarning: %s not installed\033[0K]\n" $base_name
  fi
}

# Update
source "${0:a:h}/vplugins.sh"
for plugin in $plugins; do
  printf "\rChecking %s\033[0K" $plugin
  update_vplugin ${${(P)plugin}[2]} ${${(P)plugin}[3]}
done

# Check that updates occurred
if [[ "$counter" -eq 0 ]]; then
  printf "\rNo plugin updates\033[0K\n"
else
  printf "\r\033[0K"
fi
