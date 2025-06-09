{ lib, writeShellScript, gum }: let 
in writeShellScript "user-specialisation-select" ''
  generation=$(home-manager generations | head -1 | cut -d' ' -f7)
  
  selected="$(${gum}/bin/gum choose $(ls $generation/specialisation))"
  if [[ $selected == "nothing selected" ]]; then
    echo "No specialisation selected"
    exit
  fi

  $generation/specialisation/$selected/activate
  source ~/session.start
''
