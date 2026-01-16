file:
let
  root = dirOf file;
  pipe = builtins.foldl' (x: f: f x);
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
in
pipe root [
  builtins.readDir
  (builtins.mapAttrs (file: type: if type == "directory" then "${file}/default.nix" else file))
  builtins.attrValues
  (builtins.filter (contains ''\.nix$''))
  (map (file: root + "/${file}"))
  (builtins.filter builtins.pathExists)
  (builtins.filter (path: path != file))
]
