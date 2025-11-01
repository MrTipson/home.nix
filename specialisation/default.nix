builtins.mapAttrs (name: value: { configuration = value; }) {
  Cosmic = import ./cosmic.nix;
  Hyprland = import ./hyprland.nix;
  Gnome = import ./gnome.nix;
  KDE = import ./kde.nix;
  Niri = import ./niri.nix;
  Sway = import ./sway.nix;
  "Windows XP" = import ./win-xp.nix;
  Xfce = import ./xfce.nix;
}
