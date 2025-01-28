{ config, ... }:
{
  home.file.".ssh/config".text = config.self.ssh.config;
}
