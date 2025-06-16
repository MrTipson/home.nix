{ pkgs, ... }:
{
  imports = with import ../modules; [
    graphical.gnome
  ];

  home.packages = with pkgs; [
    gnome-terminal
    nautilus
  ];

  home.file."session.start".text =
    ''exec env XDG_SESSION_TYPE=wayland dbus-run-session -- gnome-session -l'';
}
