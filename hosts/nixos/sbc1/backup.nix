{ config, inputs, ... }:
{
  homeConfig.imports = [ inputs.self.homeModules.backup ];

  homeConfig.self.backup = {
    repositoryFile = "/nix/secrets/backup.repository";
    passwordFile = "/nix/secrets/backup.password";
    paths = [ config.homeConfig.home.homeDirectory ];
    exclude = [ "${config.homeConfig.home.homeDirectory}/.*" ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };
}
