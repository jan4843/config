{ lib, ... }:
let
  opts.retention = lib.mkOption {
    type = lib.types.nullOr lib.types.ints.unsigned;
    default = null;
  };
in
{
  options.self.backup = {
    repositoryFile = lib.mkOption {
      type = lib.types.path;
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    paths = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.path;
      default = [ ];
    };

    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    retention = {
      hourly = opts.retention;
      daily = opts.retention;
      monthly = opts.retention;
      yearly = opts.retention;
    };
  };
}
