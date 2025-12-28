{ lib, ... }:
{
  options.self.bash = {
    profile = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    functions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    commandNotFound = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    preExec = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    promptCommand = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    promptInfo = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    nav = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
    };
  };
}
