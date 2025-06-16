{
  description = "Homemade packages of tipson";
  outputs = {nixpkgs, ...}:
    let
      forAllSystems = with nixpkgs; (lib.genAttrs lib.systems.flakeExposed);
    in 
      {
        packages = forAllSystems (system: import ./. (nixpkgs.legacyPackages.${system}));
      };
}
