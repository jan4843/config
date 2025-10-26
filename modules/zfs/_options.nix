{
  nixos =
    { lib, ... }:
    let
      opts.retention = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.unsigned;
        default = null;
      };
    in
    {
      options.self.zfs = {
        datasets = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                snapshots = {
                  hourly = opts.retention;
                  daily = opts.retention;
                  monthly = opts.retention;
                  yearly = opts.retention;
                };
              };
            }
          );
          default = { };
        };
      };
    };
}
