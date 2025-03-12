args: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  homeConfig.home.username = "jan";
  users.users.jan.home = "/Users/jan";

  imports = with args.inputs.self.darwinModules; [
    default

    bash
    charge-limit
    home-manager
  ];

  security.pam.enableSudoTouchIdAuth = true;
}
