{ lib, ... }:
{
  options.self.persistence = {
    path = lib.mkOption {
      default = "/nix/persist";
      readOnly = true;
    };
  };
}
