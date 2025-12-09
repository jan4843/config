{
  home-manager =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      script = pkgs.writeShellScript "backup" ''
        set -e
        export PATH=${pkgs.restic}/bin
        export RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile}
        export RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile}
        restic init || :
        restic unlock || :
        restic backup --exclude-caches --cleanup-cache \
          --files-from=${builtins.toFile "backup-paths" (lib.concatLines config.self.backup.paths)} \
          --exclude-file=${builtins.toFile "backup-exclude" (lib.concatLines config.self.backup.exclude)}
        restic check
        restic forget --prune --group-by= ${
          toString (
            lib.attrsets.mapAttrsToList (i: n: "--keep-${i}=${toString n}") config.self.backup.retention
          )
        }
      '';

      scheduleMinute =
        lib.pipe
          [
            osConfig.networking.hostName or ""
            config.home.homeDirectory
            pkgs.stdenv.hostPlatform.system
          ]
          [
            toString
            (builtins.hashString "md5")
            (builtins.substring 0 8)
            (hex: (builtins.fromTOML "x = 0x${hex}").x)
            (dec: dec - 60 * builtins.div dec 60)
          ];
    in
    lib.mkIf config.self.backup.enable {
      home.packages = with pkgs; [
        restic
        ncdu
      ];

      home.shellAliases.restic = toString [
        "RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile}"
        "RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile}"
        "restic"
      ];

      launchd.agents.backup = {
        enable = true;
        config = {
          ProgramArguments = [ "${script}" ];
          StartCalendarInterval = [ { Minute = scheduleMinute; } ];
          ProcessType = "Background";
          LowPriorityBackgroundIO = true;
        };
      };

      systemd.user = {
        services.backup = {
          Service = {
            Type = "oneshot";
            ExecStart = "${script}";
            Nice = 10;
            IOSchedulingClass = "best-effort";
            IOSchedulingPriority = 7;
          };
        };
        timers.backup = {
          Timer = {
            OnCalendar = "*:${toString scheduleMinute}";
            Unit = "backup.service";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      };
    };
}
