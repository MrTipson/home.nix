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
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkHomeConfiguration =
        system:
        {
          myconfig,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs myconfig; };
          modules = [ ./home.nix ] ++ modules;
        };
    in
    {
      homeConfigurations = {
        "tipson@masina" = mkHomeConfiguration "x86_64-linux" {
          myconfig.graphical = true;
          modules = builtins.attrValues (import ./modules/hardware/masina);
        };
        "tipson@nospit" = mkHomeConfiguration "x86_64-linux" {
          myconfig.graphical = false;
        };
      };
      homeManagerModules = import ./modules;
    };
}
