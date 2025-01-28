{ lib, ... }:
{
  options.self.ssh = {
    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };
}
