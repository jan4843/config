{ pkgs, ... }@args:
let
  helper = ".local/nix/backup/backup";

  scheduleMinute =
    args.lib.pipe
      [
        args.osConfig.networking.hostName or ""
        args.config.home.homeDirectory
        pkgs.hostPlatform.system
      ]
      [
        toString
        (builtins.hashString "md5")
        (builtins.substring 0 8)
        (hex: (builtins.fromTOML "x = 0x${hex}").x)
        (dec: dec - 60 * builtins.div dec 60)
      ];

  pkgs'.backup = pkgs.writeShellApplication {
    name = "backup";
    runtimeInputs = with pkgs; [
      rclone
      restic
    ];
    text = ''
      set -x
      export RESTIC_REPOSITORY_FILE=${args.lib.escapeShellArg args.config.self.backup.repositoryFile}
      export RESTIC_PASSWORD_FILE=${args.lib.escapeShellArg args.config.self.backup.passwordFile}
      restic init || :
      restic unlock || :
      ${args.lib.escapeShellArgs backupCmd}
      ${args.lib.escapeShellArgs forgetCmd}
      restic check
    '';
  };

  backupCmd = [
    "restic"
    "backup"
    "--files-from=${pkgs.writeText "" (args.lib.concatLines args.config.self.backup.paths)}"
    "--exclude-file=${pkgs.writeText "" (args.lib.concatLines args.config.self.backup.exclude)}"
    "--exclude-caches"
    "--exclude-if-present=CACHEDIR.TAG"
    "--cleanup-cache"
  ];

  forgetCmd = [
    "restic"
    "forget"
    "--prune"
    "--group-by="
  ] ++ args.lib.flatten retentionOpts;

  retentionOpts = args.lib.attrsets.mapAttrsToList (
    i: n: args.lib.lists.optional (n != null) "--keep-${i}=${toString n}"
  ) args.config.self.backup.retention;
in
{
  home.file.${helper}.source = args.lib.getExe pkgs'.backup;

  launchd.agents.backup = {
    enable = true;
    config = {
      ProgramArguments = [ "${args.config.home.homeDirectory}/${helper}" ];
      StartCalendarInterval = [ { Minute = scheduleMinute; } ];

      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
    };
  };

  systemd.user = {
    services.backup = {
      Service = {
        Type = "oneshot";
        ExecStart = "${args.config.home.homeDirectory}/${helper}";

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
}
