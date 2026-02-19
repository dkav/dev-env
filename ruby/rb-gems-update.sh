#!/bin/zsh
#
# Update base packages for Ruby development.

if (( $+commands[bundle] )); then
  echo "Updating Ruby Gems..."
  cd ${0:A:h} || return

  ga_update=0

  while IFS= read -r line; do
    if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
      echo "$line"
    elif [[ "$line" =~ "^Installing ([^ ]+) ([^ ]+) \(was ([^)]+)\)" ]]; then
      echo "Upgrading ${match[1]} ${match[3]} -> ${match[2]}"
      ga_update=1
    fi
  done < <(bundle update --all)

  if (( !ga_update )); then
      echo "No gems to update"
  fi

  bundle clean --force 1>/dev/null
else
  echo "Error: Bundler is not installed" >&2
fi
