{ lib, pkgs, ... }:
{
  options.self.compose = {
    projects = lib.mkOption {
      type = lib.types.attrsOf (pkgs.formats.json { }).type;
      default = { };
    };
  };
}
