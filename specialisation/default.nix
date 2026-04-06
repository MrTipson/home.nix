builtins.mapAttrs (name: value: { configuration = import value; }) {
  Cosmic = ./cosmic.nix;
  Hyprland = ./hyprland.nix;
  Gnome = ./gnome.nix;
  KDE = ./kde.nix;
  "KDE [W]" = ./kde_wl.nix;
  Niri = ./niri.nix;
  Sway = ./sway.nix;
  "Windows XP" = ./win-xp.nix;
  Xfce = ./xfce.nix;
}
