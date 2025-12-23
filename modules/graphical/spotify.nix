{
  sources,
  ...
}:
let
  spicetify-nix = import sources.spicetify-nix { };
in
{
  imports = [ spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicetify-nix.packages.extensions; [
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
