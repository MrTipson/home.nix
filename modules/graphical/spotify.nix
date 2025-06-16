{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
    ];
    enabledSnippets = [
      # hide All/Music/Podcasts toggle
      ''
        main > div:has(* [aria-label="Home Filters"]) { display: none; }
        main > section[class] { padding-top: 35px; }
      ''
    ];
    alwaysEnableDevTools = true;
  };
}
