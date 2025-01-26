{
  config,
  lib,
  pkgs,
  ...
}:
let
  opts.retention = lib.mkOption {
    type = lib.types.nullOr lib.types.ints.unsigned;
    default = null;
  };
in
{
  imports = [ ./job.nix ];

  options.self.backup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    repositoryFile = lib.mkOption {
      type = lib.types.path;
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    paths = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.path;
      default = [ ];
    };

    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    retention = {
      hourly = opts.retention;
      daily = opts.retention;
      monthly = opts.retention;
      yearly = opts.retention;
    };
  };

  config = lib.mkIf config.self.backup.enable {
    assertions = [
      {
        assertion = config.self.backup.paths != [ ];
        message = "at least one self.backup.paths must be set";
      }
      {
        assertion = builtins.any (v: !builtins.isNull v) (builtins.attrValues config.self.backup.retention);
        message = "at least one self.backup.retention policy must be set";
      }
    ];

    home.packages = with pkgs; [
      restic
      ncdu
    ];

    home.shellAliases.restic = "RESTIC_REPOSITORY_FILE=${lib.escapeShellArg config.self.backup.repositoryFile} RESTIC_PASSWORD_FILE=${lib.escapeShellArg config.self.backup.passwordFile} restic";

    self.backup = {
      repositoryFile = lib.mkDefault config.self.sideband."self.backup.repository".path;
      passwordFile = lib.mkDefault config.self.sideband."self.backup.password".path;
    };

    self.sideband = {
      "self.backup.repository".enable =
        config.self.backup.repositoryFile == config.self.sideband."self.backup.repository".path;
      "self.backup.password".enable =
        config.self.backup.passwordFile == config.self.sideband."self.backup.password".path;
    };
  };
}
