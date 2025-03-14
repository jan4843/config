args:
let
  opts.asset = args.lib.mkOption {
    type = args.lib.types.nullOr args.lib.types.path;
    default = null;
  };
in
{
  options.self.steam-shortcuts = args.lib.mkOption {
    type = args.lib.types.attrsOf (
      args.lib.types.submodule (
        { name, ... }:
        {
          options = {
            script = args.lib.mkOption {
              type = args.lib.types.str;
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
}
