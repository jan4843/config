{
  home-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      helpersRoot = ".local/nix/open-at-login";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.file = lib.mapAttrs' (name: cfg: {
        name = "${helpersRoot}/${name}";
        value.source = pkgs.writeScript name ''
          #!/bin/sh -e
          ${cfg.preExec}
          open --background -a ${lib.escapeShellArg cfg.appPath}
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
