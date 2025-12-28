lib:
let
  mapEntry =
    kind: path: filename:
    if kind == "regular" then
      lib.nameValuePair (lib.removeSuffix ".nix" filename) (import path)
    else
      lib.nameValuePair filename (scan path);
  scan =
    root:
    lib.pipe (builtins.readDir root) [
      (lib.filterAttrs (path: kind: !lib.hasPrefix "_" path && path != "default.nix"))
      (lib.filterAttrs (path: typ: typ == "directory" || (typ == "regular" && lib.hasSuffix ".nix" path)))
      (lib.mapAttrs' (path: kind: mapEntry kind (lib.path.append root path) path))
    ];
in
scan ./.
