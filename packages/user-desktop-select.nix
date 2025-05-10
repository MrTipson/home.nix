{ lib, writeShellScript, gum, desktops ? [] }: let 
  map-desktop = name: command: ''desktops["${name}"]="${command}"'';
  entries = lib.attrsets.mapAttrsToList map-desktop desktops;
in writeShellScript "user-desktop-select" ''
  declare -A desktops
  ${lib.concatStringsSep "\n" entries}

  selected="$(${gum}/bin/gum choose ''${!desktops[@]})"
  if [[ $selected == "nothing selected" ]]; then
    echo "No desktop selected"
    exit
  fi
  ''${desktops[$selected]}
''
