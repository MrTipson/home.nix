builtins.mapAttrs (name: value: { configuration = value; }) {
  Hyprland = import ./hyprland.nix;
  Gnome = import ./gnome.nix;
}