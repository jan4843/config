{ pkgs, ... }@args:
{
  home.packages = with pkgs; [
    restic
    ncdu
  ];

  home.shellAliases.restic = toString [
    "RESTIC_REPOSITORY_FILE=${args.lib.escapeShellArg args.config.self.backup.repositoryFile}"
    "RESTIC_PASSWORD_FILE=${args.lib.escapeShellArg args.config.self.backup.passwordFile}"
    "restic"
  ];
}
