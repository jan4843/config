{ lib, ... }:
{
  options.self.envs = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        {
          options = {
            vars = lib.mkOption {
              type = lib.types.attrsOf lib.types.path;
            };

            path = lib.mkOption {
              type = lib.types.path;
              readOnly = true;
              default = "${config.home.homeDirectory}/.local/nix/envs/${name}";
            };
          };
        }
      )
    );
    default = { };
  };
}
