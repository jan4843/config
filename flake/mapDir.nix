let
  pipe = builtins.foldl' (x: f: f x);

  mapDir =
    dir: fn:
    pipe dir [
      builtins.readDir
      builtins.attrNames
      (map (file: {
        name = file;
        value = dir + "/${file}";
      }))
      builtins.listToAttrs
      (builtins.mapAttrs (
        name: path:
        let
          path' = path + "/default.nix";
        in
        if builtins.pathExists path' then fn name path' else mapDir path fn
      ))
    ];
in
mapDir
