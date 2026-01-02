{
  config,
  lib,
  pkgs,
  ...
}:
let
  src = "${config.home.homeDirectory}/${config.xdg.configFile."keyd/default.conf".target}";
  dest = "/etc/keyd/default.conf";
in
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.keyd = {
    config = lib.mkOption {
      type = (pkgs.formats.ini { }).type;
      default = { };
    };
  };

  config = {
    xdg.configFile."keyd/default.conf".text = lib.generators.toINI { } config.self.keyd.config;

    home.activation.linkKeydConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.escapeShellArg config.self.sudo-passwordless.path} ln -fs ${src} ${dest}
    '';

    home.packages = [ pkgs.keyd ];

    systemd.user.services.keyd = {
      Unit = {
        X-Restart-Triggers = [ config.xdg.configFile."keyd/default.conf".source ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = lib.escapeShellArgs [
          config.self.sudo-passwordless.path
          "${pkgs.keyd}/bin/keyd"
        ];
      };
    };
  };
}
