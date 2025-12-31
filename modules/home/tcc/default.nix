{ config, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.tcc = builtins.mapAttrs (
    _: _:
    lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
    }
  ) (import ./src/services.nix config.home.homeDirectory);
}
