{
  overrides ? { },
  sources ? {
    nixpkgs = <nixpkgs>;
  }
  // import ./npins
  // overrides,
  ...
}:
let
  pkgs = import sources.nixpkgs { };
  multiseat-nix = import "/home/tipson/Dev/multiseat-nix" { overrides = sources; };
  home-manager = import (pkgs.applyPatches {
    name = "home-manager-patched";
    src = sources.home-manager;
    patches = [ ./flake-like-entrypoint.patch ];
  }) { inherit pkgs; };
  defaultConfig = {
    multiseat = false;
    graphical = false;
  };
  mkHomeConfiguration =
    {
      myconfig ? { },
      modules ? [ ],
      overlays ? [ ],
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import sources.nixpkgs { inherit overlays; };
      extraSpecialArgs = {
        inherit sources;
        myconfig = defaultConfig // myconfig;
      };
      modules = [ ./home.nix ] ++ modules;
    };
in
rec {
  homeConfigurations = {
    "masina" = mkHomeConfiguration {
      overlays = with multiseat-nix.overlays; [
        xorgserver
        kwin
      ];
      myconfig = {
        graphical = true;
        multiseat = true;
      };
      modules = with homeModules; [ graphical.multiseat ] ++ (builtins.attrValues hardware.masina);
    };
    "nospit" = mkHomeConfiguration { };
    "kista" = mkHomeConfiguration { };
  };
  homeModules = import ./modules pkgs.lib;
  patchedHM = home-manager.path;
}
