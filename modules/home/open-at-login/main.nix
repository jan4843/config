{ pkgs, ... }@args:
let
  helpersRoot = ".local/nix/open-at-login";
in
{
  home.file = args.lib.mapAttrs' (name: cfg: {
    name = "${helpersRoot}/${name}";
    value.source = pkgs.writeShellScript name ''
      ${cfg.preExec}
      open --background -a ${args.lib.strings.escapeShellArg cfg.appPath}
    '';
  }) args.config.self.open-at-login;

  launchd.agents = builtins.mapAttrs (name: cfg: {
    enable = true;
    config = {
      RunAtLoad = true;
      ProgramArguments = [ "${args.config.home.homeDirectory}/${helpersRoot}/${name}" ];
    };
  }) args.config.self.open-at-login;
}
