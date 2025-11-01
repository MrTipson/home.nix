{
  description = "Home Manager configuration of tipson";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-search-tv = {
      url = "github:3timeslazy/nix-search-tv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tipson-pkgs = {
      url = "path:./packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tipson-software = {
      url = "github:mrtipson/software.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    win-tc = {
      url = "github:mrtipson/xfce-winxp-tc/cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkHomeConfiguration =
        system:
        {
          myconfig,
          modules ? [ ],
          overlays ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system overlays; };
          extraSpecialArgs = { inherit inputs myconfig; };
          modules = [ ./home.nix ] ++ modules;
        };
    in
    {
      homeConfigurations = {
        "tipson@masina" = mkHomeConfiguration "x86_64-linux" {
          myconfig.graphical = true;
          modules = with import ./modules; ([ graphical.multiseat ] ++ (builtins.attrValues hardware.masina));
        };
        "tipson@nospit" = mkHomeConfiguration "x86_64-linux" {
          myconfig.graphical = false;
        };
      };
      homeModules = import ./modules;
    };
}
