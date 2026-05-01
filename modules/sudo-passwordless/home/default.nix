{ lib, ... }:
{
  options.self.sudo-passwordless = {
    path = lib.mkOption {
      type = lib.types.path;
    };
  };
}
