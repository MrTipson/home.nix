{ pkgs, lib, ... }:
{
  services.gnome-keyring.enable = true;
  services.polkit-gnome.enable = true;

  home.packages = with pkgs; [
    gnome-shell
    gnome-session
    gnome-control-center
    gnome-bluetooth
    gnome-settings-daemon
    gsettings-desktop-schemas
    adwaita-icon-theme
    network-manager
    gnome-menus
    uwsm
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  xdg.mime.enable = true;
}
