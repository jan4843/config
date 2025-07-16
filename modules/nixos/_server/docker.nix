args: {
  imports = with args.inputs.self.nixosModules; [
    docker
  ];

  homeConfig.self.backup = {
    paths = [
      args.config.homeConfig.home.homeDirectory
    ];
    exclude = [
      "${args.config.homeConfig.home.homeDirectory}/.*"
      "${args.config.homeConfig.home.homeDirectory}/*/cache"
    ];
  };
}
