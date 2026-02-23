#!/bin/zsh
#
# Update Miniforge.
if (( $+commands[mamba] )); then
  echo "Updating Miniforge..."
  json=$(mamba update -n base -c conda-forge -y --json --all)
  updates=$(echo "$json" | jq -r '
    if .success == false then
      "error: \(.error // "unknown error")" | halt_error(1)
    else
      .actions.UNLINK as $unlink |
      if (.actions.LINK | length) == 0 then
        "No updates"
      else
        .actions.LINK[] |
        . as $pkg |
        ($unlink | map(select(.name == $pkg.name)) | first) as $old |
        if $old then
          "2_Upgraded \($pkg.name) \($old.version) -> \($pkg.version)"
        else
          "1_Installed \($pkg.name) \($pkg.version)"
        end
      end
    end
  ' | sort | sed 's/^[12]_//')
  if (( pipestatus[1] != 0 )); then
    echo "$updates" >&2
    return 1
  fi
  echo "$updates"
else
  echo "Error: mamba is not installed" >&2
fi
