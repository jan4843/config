let
  cfg =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      args = {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    in
    {
      nixpkgs.config = args.config;
      nixpkgs.overlays = [
        (
          final: prev:
          lib.pipe inputs [
            (lib.filterAttrs (name: value: lib.hasPrefix "nixpkgs-" name))
            (builtins.mapAttrs (name: value: import value args))
          ]
        )
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
        inherit inputs lib pkgs;
      }))
      {
        home.shellAliases = {
          nixpkgs = ''_nixpkgs() { history -a; NIXPKGS_ALLOW_UNFREE=1 nix shell --impure $(printf ' nixpkgs#%s' "$@"); }; _nixpkgs'';
        };

        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      }
    ];
}
