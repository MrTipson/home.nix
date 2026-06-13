{ pkgs, lib, ... }:
let
  tpkgs = import ../../../packages pkgs;
in
{
  home.packages = [
    tpkgs.bandcamp
  ];
}
