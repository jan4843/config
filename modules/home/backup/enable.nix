{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  self.backup = {
    paths = osConfig.self.backup.paths or [ ];
    exclude = osConfig.self.backup.exclude or [ ];
  };

  home.packages = with pkgs; [
    restic
    ncdu
  ];

  home.shellAliases.restic = "RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile} RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile} restic";
}
