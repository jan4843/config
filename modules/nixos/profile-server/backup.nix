args: {
  homeConfig.imports = [ args.inputs.self.homeModules.backup ];

  homeConfig.self.backup = {
    repositoryFile = "/nix/secrets/backup.repository";
    passwordFile = "/nix/secrets/backup.password";
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };
}
