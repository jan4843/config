inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkNixpkgs = import ./mkNixpkgs.nix;
  mapDir = import ./mapDir.nix;
in
mapDir (inputs.self + "/hosts/home") (
  name: path:
  let
    inputs' = filterInputs platform inputs;
    system = eval.nixpkgs.hostPlatform;

    platform = if contains "darwin" system then "darwin" else "linux";
    eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
    expr = import path;
    contains = infix: string: builtins.length (builtins.split infix string) > 1;
  in
  inputs'.home-manager.lib.homeManagerConfiguration {
    pkgs = mkNixpkgs inputs' system;

    extraSpecialArgs = {
      inputs = inputs';
      osConfig.networking.hostName = name;
    };

    modules = [
      path
      (
        { lib, ... }:
        {
          options.nixpkgs.hostPlatform = lib.mkOption { apply = lib.systems.elaborate; };
        }
      )
    ];
  }
)
