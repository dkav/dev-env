#!/bin/zsh
#
# Update base packages for Ruby development.

setopt extended_glob

echo "Updating Ruby Gems..."
if (( $+commands[bundle] )); then
  cd ${0:A:h} || return

  had_output=false
  while IFS= read -r line; do
    if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
      echo "$line"
      had_output=true
    elif [[ "$line" =~ "^Installing ([^ ]+) ([^ ]+) \(was ([^)]+)\)" ]]; then
      echo "${match[1]} ${match[3]} -> ${match[2]}"
      had_output=true
    fi
  done < <(bundle update --all)

  if [[ "$had_output" == false ]]; then
    echo "No gems to update"
  fi

  bundle clean --force 1>/dev/null
else
  echo "Error: Bundler is not installed" >&2
fi
