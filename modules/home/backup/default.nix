{ inputs, lib, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.backup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    repositoryPrefixFile = lib.mkOption {
      type = lib.types.path;
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    paths = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.path;
    };

    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    retention = rec {
      hourly = yearly;
      daily = yearly;
      weekly = yearly;
      monthly = yearly;
      yearly = lib.mkOption { type = lib.types.ints.unsigned; };
    };
  };
}
