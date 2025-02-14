{ inputs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;

  imports = with inputs.self.darwinModules; [
    default

    bash
    charge-limit
  ];

  security.pam.enableSudoTouchIdAuth = true;
}
