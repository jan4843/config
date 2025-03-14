args:
let
  opts.retention = args.lib.mkOption {
    type = args.lib.types.nullOr args.lib.types.ints.unsigned;
    default = null;
  };
in
{
  options.self.zfs = {
    datasets = args.lib.mkOption {
      type = args.lib.types.attrsOf (
        args.lib.types.submodule {
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
    };
  };
}
