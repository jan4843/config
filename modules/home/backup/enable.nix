{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    restic
    ncdu
  ];

  home.shellAliases.restic = "RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile} RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile} restic";

  self.backup = {
    repositoryFile = lib.mkDefault config.self.sideband."self.backup.repository".path;
    passwordFile = lib.mkDefault config.self.sideband."self.backup.password".path;
  };

  self.sideband = {
    "self.backup.repository".enable =
      config.self.backup.repositoryFile == config.self.sideband."self.backup.repository".path;
    "self.backup.password".enable =
      config.self.backup.passwordFile == config.self.sideband."self.backup.password".path;
  };
}
