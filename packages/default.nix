{ callPackage, ... }:
{
  bandcamp = callPackage ./bandcamp.nix { };
  tofi-recursive-file = callPackage ./tofi-recursive-file.nix { };
  tofi-nix-run = callPackage ./tofi-nix-run.nix { };
}
