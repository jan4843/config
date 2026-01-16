fn:
let
  pipe = builtins.foldl' (x: f: f x);
  flakeExposed = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
in
pipe flakeExposed [
  (map (system: {
    name = system;
    value = fn system;
  }))
  builtins.listToAttrs
]
