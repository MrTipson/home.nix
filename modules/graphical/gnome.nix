{ pkgs, ... }:
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
    gnome-online-accounts
    gnome-menus
    uwsm
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };

  dbus.packages = with pkgs; [ gnome-online-accounts ];

  xdg.mime.enable = true;
}
