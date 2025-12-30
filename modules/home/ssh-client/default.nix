{ config, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.ssh-client = {
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = {
    home.file.".ssh/config".text = ''
      ${config.self.ssh-client.config}
      Include config@local
    '';
  };
}
