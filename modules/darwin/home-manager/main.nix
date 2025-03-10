args: {
  imports = [ args.inputs.home-manager.darwinModules.home-manager ];

  users.users.${args.config.self.username}.home =
    args.lib.mkDefault "/Users/${args.config.self.username}";
}
