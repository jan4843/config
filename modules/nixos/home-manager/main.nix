args: {
  imports = [ args.inputs.home-manager.nixosModules.home-manager ];

  self.username = args.lib.mkDefault "root";

  users.users.root.linger = args.lib.mkDefault true;
}
