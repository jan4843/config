args: {
  options.self.ssh-client = {
    config = args.lib.mkOption {
      type = args.lib.types.lines;
      default = "";
    };
  };
}
