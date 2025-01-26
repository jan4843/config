{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  helper = ".local/nix/backup/backup";

  scheduleMinute =
    lib.pipe
      [
        osConfig.networking.hostName or ""
        config.home.homeDirectory
        pkgs.hostPlatform.system
      ]
      [
        toString
        (builtins.hashString "md5")
        (builtins.substring 0 8)
        (hex: (builtins.fromTOML "x = 0x${hex}").x)
        (dec: dec - 60 * builtins.div dec 60)
      ];

  script = lib.getExe (
    pkgs.writeShellApplication {
      name = "backup";
      runtimeInputs = with pkgs; [
        rclone
        restic
      ];
      text = ''
        set -x
        export RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile}
        export RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile}
        restic init || :
        ${lib.escapeShellArgs backupCmd}
        ${lib.escapeShellArgs forgetCmd}
        restic check
      '';
    }
  );

  backupCmd = [
    "restic"
    "backup"
    "--files-from=${pkgs.writeText "" (lib.concatLines config.self.backup.paths)}"
    "--exclude-file=${pkgs.writeText "" (lib.concatLines config.self.backup.exclude)}"
    "--exclude-caches"
    "--exclude-if-present=CACHEDIR.TAG"
    "--cleanup-cache"
  ];

  forgetCmd = [
    "restic"
    "forget"
    "--prune"
    "--group-by="
  ] ++ lib.flatten retentionOpts;

  retentionOpts = lib.attrsets.mapAttrsToList (
    i: n: lib.lists.optional (n != null) "--keep-${i}=${toString n}"
  ) config.self.backup.retention;
in
lib.mkIf config.self.backup.enable {
  home.file.${helper}.source = script;

  launchd.agents.backup = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/${helper}" ];
      StartCalendarInterval = [ { Minute = scheduleMinute; } ];

      ProcessType = "Background";
      LowPriorityBackgroundIO = true;
    };
  };

  systemd.user.services.backup = {
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/${helper}";

      Nice = 10;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
    };
  };

  systemd.user.timers.backup = {
    Timer = {
      OnCalendar = "*:${toString scheduleMinute}";
      Unit = "backup.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
