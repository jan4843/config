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
  };

  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/root";
        fsType = "ext2";
        noCheck = true;
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

    boot.initrd.systemd.storePaths = config.boot.initrd.systemd.services.wipe-root.path;
    boot.initrd.systemd.services.wipe-root = {
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
}
