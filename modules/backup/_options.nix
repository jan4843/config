{
  home-manager =
    { lib, ... }:
    {
      options.self.backup = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        repositoryFile = lib.mkOption {
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
          hourly = lib.mkOption { type = lib.types.ints.unsigned; };
          daily = hourly;
          weekly = hourly;
          monthly = hourly;
          yearly = hourly;
        };
      };
    };
}
