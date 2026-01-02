{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.sudo-passwordless = {
    path = lib.mkOption {
      type = lib.types.path;
    };
  };
}
