{
  home-manager =
    { lib, ... }:
    let
      opts.asset = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    in
    {
      options.self.steam-shortcuts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                script = lib.mkOption {
                  type = lib.types.str;
                };

                assets = {
                  grid.horizontal = opts.asset;
                  grid.vertical = opts.asset;
                  hero = opts.asset;
                  logo = opts.asset;
                  icon = opts.asset;
                };
              };
            }
          )
        );
        default = { };
      };
    };
}
