{ pkgs, ... }@args:
let
  services = import ./_files/services.nix args.config.home.homeDirectory;
in
{
  self.scripts.check.tcc = {
    path = [ "darwin" ];
    text = ''
      if ! head -c1 ${args.lib.strings.escapeShellArg services.SystemPolicyAllFiles.database} &>/dev/null; then
        echo "the application running this script does not have full disk access"
        exit 1
      fi
    '';
  };

  self.scripts.write = args.lib.mapAttrs' (name: service: {
    name = "tcc-${name}";
    value = {
      path = [ "darwin" ];
      text = ''
        TCC_DATABASE=${args.lib.escapeShellArg service.database} \
        TCC_SERVICE=kTCCService${args.lib.escapeShellArg name} \
        PREFPANE=${args.lib.escapeShellArg service.prefpane} \
        ${args.lib.getExe pkgs.bash} ${./_files/tcc.bash} \
        ${args.lib.escapeShellArgs args.config.self.tcc.${name}}
      '';
    };
  }) services;
}
