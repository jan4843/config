inputs: fn:
let
  pipe = builtins.foldl' (x: f: f x);
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;

  flakeExposed = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
in
pipe flakeExposed [
  (map (
    system:
    let
      platform = if contains "darwin" system then "darwin" else "linux";
      inputs' = filterInputs platform inputs;
    in
    {
      name = system;
      value = fn rec {
        inputs = inputs';
        lib = pkgs.lib;
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              self = inputs.self.packages.${system};
              lib = mkLib inputs;
            })
          ];
        };
      };
    }
  ))
  builtins.listToAttrs
]
