{ inputs, pkgs, ... }:
let
  inherit (inputs.tipson-software.packages.${pkgs.system})
    sway
    ;
in
{
  wayland.windowManager.sway.package = sway;
}
