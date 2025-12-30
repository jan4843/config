{
  lib,
  homeConfig,
  inputs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/desktop-extra")
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  homeConfig.home.username = "jan";
  homeConfig.home.stateVersion = "25.05";

  homeConfig.self.backup = {
    paths = [
      "${homeConfig.home.homeDirectory}/Documents"
      "${homeConfig.home.homeDirectory}/Developer"
      "${homeConfig.home.homeDirectory}/Library/LaunchAgents/local.*"
      "${homeConfig.home.homeDirectory}/Library/Mobile Documents/9CR7T2DMDG~com~ngocluu~onewriter/Documents"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
      weekly = 0;
      monthly = 0;
      yearly = 0;
    };
  };
}
