builtins.mapAttrs (name: value: { configuration = value; }) {
  Hyprland = import ./hyprland.nix;
  Gnome = import ./gnome.nix;
  KDE = import ./kde.nix;
  Niri = import ./niri.nix;
}
