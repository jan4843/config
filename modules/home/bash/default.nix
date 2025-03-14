args: {
  options.self.bash = rec {
    PS1 = args.lib.mkOption {
      type = args.lib.types.nullOr args.lib.types.str;
      default = null;
    };
    PS2 = PS1;
    PS3 = PS1;
    PS4 = PS1;

    promptInfo = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    commandNotFound = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    promptCommand = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    preExec = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    variables = args.lib.mkOption {
      type = args.lib.types.attrs;
      default = { };
    };

    aliases = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    functions = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.str;
      default = { };
    };

    profile = args.lib.mkOption {
      type = args.lib.types.lines;
      default = "";
    };
  };
}
