{ inputs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  self.username = "jan";

  imports = with inputs.self.darwinModules; [
    default

    bash
    charge-limit
    home-manager
  ];

  security.pam.enableSudoTouchIdAuth = true;
}
