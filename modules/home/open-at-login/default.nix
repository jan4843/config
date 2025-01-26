{
  config,
  lib,
  pkgs,
  ...
}:
let
  helpersRoot = ".local/nix/open-at-login";
in
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

  config = lib.mkIf pkgs.hostPlatform.isDarwin {
    home.file = lib.mapAttrs' (name: cfg: {
      name = "${helpersRoot}/${name}";
      value.source = pkgs.writeShellScript name ''
        ${cfg.preExec}
        open --background -a ${lib.strings.escapeShellArg cfg.appPath}
      '';
    }) config.self.open-at-login;

    launchd.agents = builtins.mapAttrs (name: cfg: {
      enable = true;
      config = {
        RunAtLoad = true;
        ProgramArguments = [ "${config.home.homeDirectory}/${helpersRoot}/${name}" ];
      };
    }) config.self.open-at-login;
  };
}
