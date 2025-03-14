args: {
  options.self.persistence = {
    path = args.lib.mkOption {
      default = "/nix/persist";
      readOnly = true;
    };
  };
}
