{
  sources,
  ...
}:
let
  inherit ((import sources.multiseat-nix { overrides = sources; }).packages)
    sway
    ;
in
{
  wayland.windowManager.sway.package = sway;
}
