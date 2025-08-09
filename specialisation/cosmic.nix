{ pkgs, ... }:
{
  imports = with import ../modules; [
    graphical.cosmic
  ];

  home.packages = with pkgs; [
    cosmic-edit
    cosmic-term
    cosmic-files
    cosmic-player
    cosmic-wallpapers
    cosmic-ext-calculator
  ];

  home.file."session.start".text = ''exec start-cosmic --in-login-shell'';
}
