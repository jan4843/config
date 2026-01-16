{
  inputs,
  lib,
  pkgs,
  ...
}@args:
lib.mkIf (!args.osConfig.home-manager.useGlobalPkgs or false) {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = lib.singleton (
    final: prev:
    lib.pipe inputs [
      (lib.filterAttrs (name: value: lib.hasPrefix "nixpkgs-" name))
      (builtins.mapAttrs (
        name: value:
        import value {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        }
      ))
    ]
  );
}
