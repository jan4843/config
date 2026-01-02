{
  config,
  homeConfig,
  lib,
  pkgs,
  ...
}:
{
  security.sudo.extraConfig = ''
    ${homeConfig.home.username} ALL=(ALL) NOPASSWD: ALL
  '';

  homeConfig.self.sudo-passwordless.path = "${config.security.wrapperDir}/${lib.getExe pkgs.sudo}";
}
