{
  pkgs,
  config,
  lib,
  ...
}:
let
  lynx = lib.getExe pkgs.lynx;
  fzf = lib.getExe pkgs.fzf;
  jq = lib.getExe pkgs.jq;
  nstv = lib.getExe config.programs.nix-search-tv.package;
  mkFzf =
    _: index:
    ''${nstv} print --indexes ${index} | ${fzf} --preview "${nstv} preview --indexes ${index} {}"'';
in
{
  home.shellAliases = {
    # nix-build --extra-experimental-features flakes --expr "(builtins.getFlake github:nix-community/noogle).outputs.packages.\${builtins.currentSystem}.ui.overrideAttrs (old: { patches = [ ./noogle.patch ]; })" -o ~/.cache/noogle
    "lang" =
      ''${jq} -r '.data.[].meta.path | join(".")' ~/.cache/noogle/api/v1/data | ${fzf} --preview "printf '{}' | sed 's/\./\//g' | xargs -0 -I%s ${lynx} -dump -nolist '~/.cache/noogle/f/%s.html'"'';
  }
  // builtins.mapAttrs mkFzf {
    "hm" = "home-manager";
    "nixos" = "nixos";
    "pkgs" = "nixpkgs";
  };
  programs.nix-search-tv.enable = true;
}
