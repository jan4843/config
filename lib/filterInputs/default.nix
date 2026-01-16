system: set:
let
  pipe = builtins.foldl' (x: f: f x);
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
  suffix = if contains "darwin" system then "darwin" else "linux";
in
pipe set [
  builtins.attrNames
  (builtins.filter (name: contains "_${suffix}$" name || !contains "_" name))
  (map (name: {
    name = builtins.replaceStrings [ "_${suffix}" ] [ "" ] name;
    value = set.${name};
  }))
  builtins.listToAttrs
]
