{ lib, ... }:
{
  options.self.bash = rec {
    PS1 = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    PS2 = PS1;
    PS3 = PS1;
    PS4 = PS1;

    promptInfo = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    commandNotFound = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    promptCommand = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    preExec = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    variables = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    functions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };

    profile = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };
}
