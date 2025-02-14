{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.backup ];

  self.backup = {
    paths = [
      "${config.home.homeDirectory}/Documents"
      "${config.home.homeDirectory}/Developer"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };
}
