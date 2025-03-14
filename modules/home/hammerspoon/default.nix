args: {
  options.self.hammerspoon = {
    spoons = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };
  };
}
