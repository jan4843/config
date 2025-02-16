{ config, lib, ... }:
let
  services = import ./files/services.nix config.home.homeDirectory;
in
{
  options.self.tcc = builtins.mapAttrs (
    _: _:
    lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
    }
  ) services;
}
