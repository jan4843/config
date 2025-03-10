args: {
  imports = [
    (args.lib.mkAliasOptionModule [ "homeConfig" ] [ "home-manager" "users" args.config.self.username ])
  ];

  options.self.username = args.lib.mkOption { };

  config.home-manager = {
    extraSpecialArgs.inputs = args.inputs;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
