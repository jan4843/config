{ lib, ... }:
{
  options.self.homebrew = {
    prefix = lib.mkOption {
      type = lib.types.path;
      default = "/opt/homebrew";
      readOnly = true;
    };

    taps = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    mas = lib.mkOption {
      type = lib.types.attrsOf lib.types.ints.unsigned;
      default = { };
    };
  };
}
