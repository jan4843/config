args: {
  options.self.caddy = {
    sites = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };
  };
}
