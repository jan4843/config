args: {
  imports = [ args.inputs.home-manager.nixosModules.home-manager ];

  users.users.root.linger = args.lib.mkDefault true;
}
