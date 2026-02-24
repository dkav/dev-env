#!/bin/zsh
#
# Update outdated global npm packages.
#

if (( $+commands[npm] )); then
  echo "Updating Node Packages..."
  no=$(npm outdated --global --json --depth=0 --quiet 2>/dev/null || true)

  if [[ -n $no && $no != "{}" ]]; then
    pkgs=()
    while read -r pkg cver pver; do
      echo "$pkg $cver -> $pver"
      pkgs+=("$pkg@$pver")
    done < <(echo "$no" | jq -r 'to_entries[] | "\(.key) \(.value.current) \(.value.latest)"')

    npm install --global --no-fund --no-progress --quiet "${pkgs[@]}" 1>/dev/null
  else
    echo "No packages to update"
  fi
else
  echo "Error: npm is not installed" >&2
fi
