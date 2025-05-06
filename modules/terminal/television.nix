{ inputs, system, pkgs, ... }:
{
  home.packages = with pkgs; [
    television
    inputs.nix-search-tv.packages.${system}.default
  ];
  xdg.configFile."television/nix_channels.toml".text = ''
    [[cable_channel]]
    name = "nixpkgs"
    source_command = "nix-search-tv print"
    preview_command = "nix-search-tv preview {}"
  '';
  xdg.configFile."nix-search-tv/config.json".text = ''
  {
    "indexes": ["nixpkgs", "home-manager", "nur", "nixos" ]
  }
  '';
}
