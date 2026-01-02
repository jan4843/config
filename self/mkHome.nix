inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
  mapDir = import ./mapDir.nix;
in
mapDir (inputs.self + "/hosts/home") (
  name: path:
  let
    inputs' = filterInputs platform inputs;
    lib' = mkLib inputs';
    system = eval.nixpkgs.hostPlatform;

    platform = if contains "darwin" system then "darwin" else "linux";
    eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
    expr = import path;
    contains = infix: string: builtins.length (builtins.split infix string) > 1;
  in
  inputs'.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs'.nixpkgs.legacyPackages.${system};
    lib = lib';

    extraSpecialArgs = {
      inputs = inputs';
      osConfig.networking.hostName = name;
    };

    modules = [
      path
      { options.nixpkgs.hostPlatform = lib'.mkOption { apply = lib'.systems.elaborate; }; }
      {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          (final: prev: {
            self = inputs.self.packages.${system};
            lib = lib';
          })
        ];
      }
    ];
  }
)
