{ inputs, pkgs, ... }:
let
  inherit (inputs.multiseat-nix.packages.${pkgs.system})
    sway
    ;
in
{
  wayland.windowManager.sway.package = sway;
}
