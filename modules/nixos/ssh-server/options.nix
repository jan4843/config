{ lib, ... }:
{
  options.self.ssh-server = {
    importID = lib.mkOption {
      type = lib.types.str;
    };
  };
}
