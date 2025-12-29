{ homeConfig, ... }:
{
  security.sudo.extraConfig = ''
    ${homeConfig.home.username} ALL=(ALL) NOPASSWD: ALL
  '';
}
