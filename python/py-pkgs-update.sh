#!/bin/zsh
#
# Update outdated base Python packages.

function venv_update() {
  # $1 - venv name; $2 - path to req file
  printf "\nUpdate %s virtual environment\n" $1
  source $HOME/.local/pyvenvs/$1/bin/activate
  export PIP_DISABLE_PIP_VERSION_CHECK=1
  export PYTHONWARNINGS="ignore:DEPRECATION"
  rpkgs=$(sed '/#.*/d;/^$/d;s/$/\ /' $2/venv-$1-reqs.in)
  plst=$(pip3 list --outdated)
  opkgs=$(echo $plst | grep -E $rpkgs)
  if [[ -n $opkgs ]]; then
    echo $plst | head -2
    echo $opkgs \
      | tee "$(tty)" \
      | cut -d ' ' -f 1 \
      | xargs pip3 install --upgrade --quiet
  deactivate
  else
    echo "No $1 libraries to update"
  fi
}

if [ -x "$(command -v $HOMEBREW_PREFIX/bin/pipx)" ]; then
  echo "Updating Python Packages..."
  export USE_EMOJI=0
  echo "Update python apps"
  pipx upgrade-all --include-injected
  req_path=${0:a:h}
  venv_update pydata $req_path
else
  echo "Error: pipx is not installed" >&2
fi
