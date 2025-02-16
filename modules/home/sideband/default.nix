{ config, lib, ... }:
{
  options.self.sideband = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };

            path = lib.mkOption {
              type = lib.types.path;
              readOnly = true;
              default = "${config.home.homeDirectory}/.local/nix/sideband/${name}";
            };
          };
        }
      )
    );
    default = { };
  };
}
