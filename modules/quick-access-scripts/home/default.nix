{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.self.quick-access-scripts = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
  };

  config = {
    systemd.user.services.quick-access-scripts = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = lib.escapeShellArgs [
          "${(pkgs.callPackage ./src { })}/bin/quickaccessscripts"
        ];
      };
    };

    xdg.configFile = lib.mapAttrs' (name: value: {
      name = "quick-access-scripts/${name}";
      value.source = lib.getExe (
        pkgs.writeShellApplication {
          name = name;
          text = value;
        }
      );
    }) config.self.quick-access-scripts;
  };
}
