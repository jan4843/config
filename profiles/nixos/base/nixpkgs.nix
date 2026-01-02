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
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = lib.optional (!args.osConfig.home-manager.useGlobalPkgs or false) (
    final: prev:
    lib.pipe inputs [
      (lib.filterAttrs (name: value: lib.hasPrefix "nixpkgs-" name))
      (builtins.mapAttrs (name: value: import value cfg))
    ]
  );
}
