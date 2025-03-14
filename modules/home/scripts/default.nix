args: {
  options.self.scripts = rec {
    check = args.lib.mkOption {
      type = args.lib.types.attrsOf (
        args.lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              path = args.lib.mkOption {
                type = args.lib.types.listOf (
                  args.lib.types.either args.lib.types.package (args.lib.types.enum [ "darwin" ])
                );
                default = [ ];
              };

              text = args.lib.mkOption { type = args.lib.types.lines; };
            };
          }
        )
      );
      default = { };
    };

    install = check;

    write = check;
  };
}
