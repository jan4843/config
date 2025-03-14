args: {
  options.self.plistbuddy = args.lib.mkOption {
    type = args.lib.types.listOf (
      args.lib.types.submodule {
        options = {
          command = args.lib.mkOption {
            type = args.lib.types.str;
          };

          file = args.lib.mkOption {
            type = args.lib.types.path;
          };
        };
      }
    );
    default = [ ];
  };
}
