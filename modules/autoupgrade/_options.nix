{
  nixos =
    { lib, ... }:
    {
      options.self.autoupgrade = {
        flakeref = lib.mkOption {
          type = lib.types.str;
        };

        schedule = lib.mkOption {
          type = lib.types.str;
        };
      };
    };
}
