{ config, inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    profiles.desktop.extra
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  homeConfig.home.username = "jan";
  homeConfig.home.stateVersion = "25.05";

  homeConfig.self.backup = {
    paths = [
      "${config.homeConfig.home.homeDirectory}/Documents"
      "${config.homeConfig.home.homeDirectory}/Developer"
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
