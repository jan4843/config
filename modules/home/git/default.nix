{ pkgs, ... }@args:
{
  options.self.git = {
    package = args.lib.mkOption {
      type = args.lib.types.package;
      default = pkgs.git;
    };

    config = args.lib.mkOption {
      type = args.lib.types.anything;
      default = [ ];
    };

    ignore = args.lib.mkOption {
      type = args.lib.types.listOf args.lib.types.str;
      default = [ ];
    };

    hooks = args.lib.mkOption {
      type = args.lib.types.attrsOf (args.lib.types.attrsOf args.lib.types.path);
      default = { };
    };
  };
}
