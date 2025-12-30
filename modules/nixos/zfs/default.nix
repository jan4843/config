{ config, lib, ... }:
let
  opts.retention = lib.mkOption {
    type = lib.types.nullOr lib.types.ints.unsigned;
    default = null;
  };
in
{
  imports = lib.self.siblingsOf ./default.nix;

  options.self.zfs = {
    datasets = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            snapshots = {
              hourly = opts.retention;
              daily = opts.retention;
              monthly = opts.retention;
              yearly = opts.retention;
            };
          };
        }
      );
      default = { };
    };
  };

  config = {
    boot.supportedFilesystems = [ "zfs" ];

    boot.zfs = {
      forceImportAll = true;
      extraPools = lib.pipe config.self.zfs.datasets [
        builtins.attrNames
        (map (x: builtins.head (builtins.split "/" x)))
        lib.unique
      ];
    };

    networking.hostId = lib.mkDefault "00000000";

    services.zfs.autoScrub = {
      enable = true;
      interval = "Sun 04:00";
    };

    services.sanoid = {
      enable = true;
      datasets = builtins.mapAttrs (
        name: value:
        value.snapshots
        // {
          autosnap = true;
          autoprune = true;
        }
      ) config.self.zfs.datasets;
    };
  };
}
