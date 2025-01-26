{
  config,
  lib,
  pkgs,
  ...
}:
let
  services = import ./services.nix config.home.homeDirectory;
in
{
  options.self.tcc = builtins.mapAttrs (
    _: _:
    lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
    }
  ) services;

  config = lib.mkIf pkgs.hostPlatform.isDarwin {
    self.scripts.check.tcc = {
      path = [ "darwin" ];
      text = ''
        if ! head -c1 ${lib.strings.escapeShellArg services.SystemPolicyAllFiles.database} &>/dev/null; then
          echo "the application running this script does not have full disk access"
          exit 1
        fi
      '';
    };

    self.scripts.write = lib.mapAttrs' (name: service: {
      name = "tcc-${name}";
      value = {
        path = [ "darwin" ];
        text = ''
          TCC_DATABASE=${lib.escapeShellArg service.database} \
          TCC_SERVICE=kTCCService${lib.escapeShellArg name} \
          PREFPANE=${lib.escapeShellArg service.prefpane} \
          ${lib.getExe pkgs.bash} ${./tcc.bash} \
          ${lib.escapeShellArgs config.self.tcc.${name}}
        '';
      };
    }) services;
  };
}
