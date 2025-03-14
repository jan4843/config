args: {
  options.self.alfred = {
    syncFolder = args.lib.mkOption {
      type = args.lib.types.path;
    };

    preferences = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.anything;
      default = { };
    };
  };
}
