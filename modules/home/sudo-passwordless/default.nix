{ inputs, lib, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.sudo-passwordless = {
    path = lib.mkOption {
      type = lib.types.path;
    };
  };
}
