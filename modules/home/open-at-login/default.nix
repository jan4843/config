args: {
  options.self.open-at-login = args.lib.mkOption {
    type = args.lib.types.attrsOf (
      args.lib.types.submodule {
        options = {
          appPath = args.lib.mkOption {
            type = args.lib.types.path;
          };

          preExec = args.lib.mkOption {
            type = args.lib.types.str;
            default = "";
          };
        };
      }
    );
    default = { };
  };
}
