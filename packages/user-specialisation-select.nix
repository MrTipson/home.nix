{ lib, writeShellScript, gum }: let 
in writeShellScript "user-specialisation-select" ''
  
  selected=$(${gum}/bin/gum choose $(ls ~/specialisation))
  if [[ $selected == "" ]]; then
    exit
  fi

  ~/specialisation/$selected/activate
  source ~/session.start
''
