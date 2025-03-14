{ config, ... }:
{
  home.file.".ssh/config".text = config.self.ssh-client.config;
}
