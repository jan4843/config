args: {
  homeConfig.imports = [ args.inputs.self.homeModules.backup ];

  homeConfig.self.backup = {
    repositoryFile = "/nix/secrets/backup.repository";
    passwordFile = "/nix/secrets/backup.password";
    paths = [
      "${args.config.homeConfig.home.homeDirectory}/Documents"
      "${args.config.homeConfig.home.homeDirectory}/Developer"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };
}
