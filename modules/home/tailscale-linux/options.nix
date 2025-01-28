{ lib, ... }:
{
  options.self.tailscale = {
    authKeyFile = lib.mkOption {
      type = lib.types.path;
    };

    tags = lib.mkOption {
      type = lib.types.nonEmptyListOf (lib.types.strMatching "[a-zA-Z][a-zA-Z0-9-]*");
    };

    upFlags = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "--.+");
      default = [ ];
    };
  };
}
