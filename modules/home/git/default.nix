{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.git = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.git;
    };

    config = lib.mkOption {
      type = lib.types.anything;
      default = [ ];
    };

    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    hooks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.path);
      default = { };
    };
  };
}
