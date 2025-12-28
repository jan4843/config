{ config, ... }:
{
  home.file.".ssh/config".text = ''
    ${config.self.ssh-client.config}
    Include config@local
  '';
}
