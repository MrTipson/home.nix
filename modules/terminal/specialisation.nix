{ pkgs, ... }: {
  programs.fish.loginShellInit = ''
    set selected (${pkgs.gum}/bin/gum choose (ls ~/specialisation))

    if test -n "$selected"
      ~/specialisation/"$selected"/activate
      source ~/session.start
    end
  '';
  specialisation = import ../../specialisation;

  home.activation."specialisationSetup" = ''
    if [[ -e $newGenPath/specialisation ]]; then
      test -h specialisation && unlink specialisation
      ln -s $newGenPath/specialisation
    fi
  '';
}