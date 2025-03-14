args:
let
  opts.retention = args.lib.mkOption {
    type = args.lib.types.nullOr args.lib.types.ints.unsigned;
    default = null;
  };
in
{
  options.self.backup = {
    repositoryFile = args.lib.mkOption {
      type = args.lib.types.path;
    };

    passwordFile = args.lib.mkOption {
      type = args.lib.types.path;
    };

    paths = args.lib.mkOption {
      type = args.lib.types.nonEmptyListOf args.lib.types.path;
      default = [ ];
    };

    exclude = args.lib.mkOption {
      type = args.lib.types.listOf args.lib.types.str;
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
