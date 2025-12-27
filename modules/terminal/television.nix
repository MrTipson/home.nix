{
  pkgs,
  config,
  lib,
  ...
}:
let
  nstv = lib.getExe config.programs.nix-search-tv.package;
  mkNixSearchTv =
    name: description: index:
    lib.nameValuePair name {
      metadata = { inherit name description; };
      source.command = "${nstv} print --indexes ${index}";
      preview.command = ''${nstv} preview --indexes ${index} "{}"'';
    };
in
{
  programs.television = {
    enable = true;
    channels = lib.listToAttrs [
      (mkNixSearchTv "pkgs" "Nixpkgs packages" "nixpkgs")
      (mkNixSearchTv "nixos" "NixOS options" "nixos")
      (mkNixSearchTv "hm" "Home manager options" "home-manager")
      # nix-build --extra-experimental-features flakes --expr "(builtins.getFlake github:nix-community/noogle).outputs.packages.\${builtins.currentSystem}.ui.overrideAttrs (old: { patches = [ ./noogle.patch ]; })" -o ~/.cache/noogle
      (lib.nameValuePair "nix" {
        metadata = {
          name = "nix";
          description = "Nix builtins and standard library";
        };
        source.command = "${lib.getExe pkgs.jq} -r '.data.[].meta.path | join(\".\")' ~/.cache/noogle/api/v1/data | sort";
        preview.command = ''printf "{}" | sed "s/\./\//g" | xargs -0 -I%s ${lib.getExe pkgs.lynx} -dump -nolist "~/.cache/noogle/f/%s.html"'';
      })
    ];
    settings = {
      tick_rate = 50;
      ui = {
        use_nerd_font_icons = true;
        ui_scale = 120;
      };
    };
  };
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = false;
  };
}
