#!/bin/zsh
#
# Update outdated global npm packages.
#

if (( $+commands[npm] )); then
  echo "Updating Node Packages..."
  no=(${(f)"$(sed '/#.*/d;/^$/d' ${0:a:h}/node-requirements.txt \
      | xargs npm outdated --global --parseable --depth=0 --quiet)"})
  if [[ -n $no ]]; then
    for line in $no; do
      fields=("${(@s/:/)line}")
      current=$fields[3]    # @github/copilot-cli@0.0.410
      latest=$fields[4]     # @github/copilot-cli@0.0.411
      pkg="${latest%@*}"    # @github/copilot-cli
      cver="${current##*@}" # 0.0.410
      pver="${latest##*@}"  # 0.0.411
      echo "Updating $pkg $cver -> $pver"
      npm install --global --no-fund --no-progress --quiet "$latest" 1>/dev/null
    done
  else
    echo "No packages to update"
  fi
else
  echo "Error: npm is not installed" >&2
fi
