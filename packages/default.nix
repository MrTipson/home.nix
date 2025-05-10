{ callPackage, ... }: {
  tofi-recursive-file = callPackage ./tofi-recursive-file.nix {};
  tofi-nix-run = callPackage ./tofi-nix-run.nix {};
  user-desktop-select = callPackage ./user-desktop-select.nix {};
}