#!/bin/zsh
#
# Update outdated base Python packages.

function venv_update() {
  # $1 - venv name; $2 - path to req file
  printf "\nUpdate %s virtual environment:\n" $1

  package_updated=false
  while IFS= read -r line; do
    if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
      echo "$line"
    fi

    if [[ "$line" =~ "^ - (.+)==(.+)$" ]]; then
      package="${match[1]}"
      old_version="${match[2]}"
    elif [[ "$line" =~ "^ \+ (.+)==(.+)$" ]] && [[ -n "$package" ]]; then
      new_version="${match[2]}"
      echo "$package $old_version->$new_version"
      package=""
      package_updated=true
    fi
  done < <(uv tool upgrade --all --no-progress --color never 2>&1)

  if [[ "$package_updated" == false ]]; then
    echo "No $1 libraries to update"
  fi
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/uv)" ]; then
  echo "Updating Python Packages..."

echo "Update Python apps:"
uv tool upgrade --all --no-progress --color never 2>&1 | while IFS= read -r line; do
  if [[ "$line" == *((#i)(error|failed|fatal|critical|warning))* ]]; then
    echo "$line"
  elif [[ "$line" =~ "Updated" ]]; then
    echo "$line"
  elif [[ "$line" == "Nothing to upgrade" ]]; then
    echo "No app updates"
  fi
done

  req_path=${0:a:h}
  venv_update pydata $req_path
else
  echo "Error: uv is not installed" >&2
fi
