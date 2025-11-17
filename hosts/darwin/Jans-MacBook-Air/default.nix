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
      "${config.homeConfig.home.homeDirectory}/Library/Mobile Documents/com~apple~CloudDocs/Notes"
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
