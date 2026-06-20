{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.self.persistence = {
    path = lib.mkOption {
      default = "/nix/persist";
      readOnly = true;
    };

    wipeRoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/root";
        fsType = "auto";
        noCheck = config.self.persistence.wipeRoot;
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "auto";
      };
      "/nix" = {
        device = "/dev/disk/by-label/nix";
        fsType = "auto";
      };

      "/root" = {
        device = "${config.self.persistence.path}/root";
        options = [ "bind" ];
        fsType = "none";
      };

      "/home" = {
        device = "${config.self.persistence.path}/home";
        options = [ "bind" ];
        fsType = "none";
      };

      "/var/log/journal" = {
        device = "${config.self.persistence.path}/journal";
        options = [ "bind" ];
        fsType = "none";
      };
    };

    boot.initrd.systemd = lib.mkIf config.self.persistence.wipeRoot {
      storePaths = config.boot.initrd.systemd.services.wipe-root.path;
      services.wipe-root = {
        wantedBy = [ "initrd.target" ];
        after = [ "initrd-root-device.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        path = [ pkgs.e2fsprogs ];
        script = ''
          mkfs.ext2 -F -L root /dev/disk/by-partlabel/root
        '';
      };
    };
  };
}
