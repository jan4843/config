{ lib, ... }:
{
  options.self.scripts = rec {
    check = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              path = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.package (lib.types.enum [ "darwin" ]));
                default = [ ];
              };

              text = lib.mkOption { type = lib.types.lines; };
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
