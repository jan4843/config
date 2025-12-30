{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.ssh-server = {
    importID = lib.mkOption {
      type = lib.types.str;
    };
  };
}
