args: {
  options.self.ssh-server = {
    importID = args.lib.mkOption {
      type = args.lib.types.str;
    };
  };
}
