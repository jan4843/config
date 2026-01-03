{ homeConfig, ... }:
{
  security.sudo.extraConfig = ''
    ${homeConfig.home.username} ALL=(ALL) NOPASSWD: ALL
  '';

  homeConfig.self.sudo-passwordless.path = "/usr/bin/sudo";
}
