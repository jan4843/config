{
  home-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      services = import ./.src/services.nix config.home.homeDirectory;
    in
    lib.mkIf pkgs.hostPlatform.isDarwin {
      home.activation.checkFullDiskAccess = lib.hm.dag.entryBefore [ "checkFilesChanged" ] ''
        if ! head -c1 ${lib.escapeShellArg services.SystemPolicyAllFiles.database} &>/dev/null; then
          echo "the application running this script does not have full disk access"
          exit 1
        fi
      '';

      home.activation.ensureTCCPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] (
        lib.concatMapAttrsStringSep "\n" (
          name: service:
          lib.optionalString (config.self.tcc.${name} != [ ]) ''
            TCC_DATABASE=${lib.escapeShellArg service.database} \
            TCC_SERVICE=kTCCService${lib.escapeShellArg name} \
            PREFPANE=${lib.escapeShellArg service.prefpane} \
            ${lib.getExe pkgs.bash} ${./.src/tcc.bash} \
            ${lib.escapeShellArgs config.self.tcc.${name}}
          ''
        ) services
      );
    };
}
