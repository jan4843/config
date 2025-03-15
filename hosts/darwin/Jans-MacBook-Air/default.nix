args: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  homeConfig.home.username = "jan";

  imports = with args.inputs.self.darwinModules; [
    default

    bash
    charge-limit
    home-manager
  ];

  security.sudo.extraConfig = ''
    %admin ALL=(ALL) NOPASSWD: ALL
  '';
}
