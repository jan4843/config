{
  inputs,
  lib,
  pkgs,
  ...
}@args:
let
  cfg = {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
lib.mkIf (!args.osConfig.home-manager.useGlobalPkgs or false) {
  nixpkgs.config = cfg.config;
  nixpkgs.overlays = [
    (
      final: prev:
      lib.pipe inputs [
        (lib.filterAttrs (name: value: lib.hasPrefix "nixpkgs-" name))
        (builtins.mapAttrs (name: value: import value cfg))
      ]
    )
  ];
}
