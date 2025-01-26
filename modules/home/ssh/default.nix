{ config, lib, ... }:
{
  imports = [ ./darwin.nix ];

  options.self.ssh = {
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = {
    home.file.".ssh/config".text = config.self.ssh.config;
  };
}
