{
  home-manager =
    { lib, ... }:
    {
      options.self.open-at-login = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              appPath = lib.mkOption {
                type = lib.types.path;
              };

              preExec = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
            };
          }
        );
        default = { };
      };
    };
}
