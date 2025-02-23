{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.backup ];

  self.backup = {
    repositoryFile = "/nix/secrets/backup.repository";
    passwordFile = "/nix/secrets/backup.password";
    paths = [ config.home.homeDirectory ];
    exclude = [ "${config.home.homeDirectory}/.*" ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };
}
