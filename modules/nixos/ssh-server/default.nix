{ inputs, lib, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.ssh-server = {
    importID = lib.mkOption {
      type = lib.types.str;
    };
  };
}
