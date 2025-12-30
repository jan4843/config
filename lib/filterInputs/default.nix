{ ... }:
platform: inputs:
let
  pipe = builtins.foldl' (x: f: f x);
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
in
pipe inputs [
  builtins.attrNames
  (builtins.filter (name: contains "_${platform}$" name || !contains "_" name))
  (map (name: {
    name = builtins.replaceStrings [ "_${platform}" ] [ "" ] name;
    value = inputs.${name};
  }))
  builtins.listToAttrs
]
