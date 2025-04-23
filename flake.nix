{
  description = "Home Manager configuration of tipson";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."tipson" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs; 
          myconfig = { graphical = true; };
        };
        inherit pkgs;
        useGlobalPkgs = true;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          # hyprland
          # waybar
          inputs.stylix.homeManagerModules.stylix
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
