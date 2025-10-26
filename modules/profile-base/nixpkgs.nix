let
  cfg =
    { inputs, pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = pkgs.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
      ];
    };
in
{
  nixos = cfg;

  nix-darwin = cfg;

  home-manager =
    {
      inputs,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    lib.mkMerge [
      (lib.mkIf (!osConfig.home-manager.useGlobalPkgs or false) (cfg {
        inherit inputs pkgs;
      }))
      {
        home.shellAliases = {
          nixpkgs = ''_nixpkgs() { NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$1"; }; _nixpkgs'';
        };

        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      }
    ];
}
