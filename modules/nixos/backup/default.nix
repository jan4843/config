{ lib, ... }:
{
  options.self.backup = {
    paths = lib.mkOption {
      default = [ ];
    };

    exclude = lib.mkOption {
      default = [ ];
    };
  };
}
