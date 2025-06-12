{ pkgs, inputs, ... }:
{
  imports = with import ../modules; with graphical; [
    gnome
  ];
  
  home.packages = with pkgs; [
    gnome-terminal
    nautilus
  ];

  home.file."session.start".text = ''gnome-session --systemd-service & uwsm start gnome-shell'';
}
