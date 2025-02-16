{ config, ... }:
{
  fileSystems = {
    "/".device = "/dev/disk/by-label/root";
    "/boot".device = "/dev/disk/by-label/boot";
    "/nix".device = "/dev/disk/by-label/nix";

    "/root" = {
      device = "${config.self.persistence.path}/root";
      options = [ "bind" ];
    };

    "/home" = {
      device = "${config.self.persistence.path}/home";
      options = [ "bind" ];
    };
  };

  boot.initrd.postDeviceCommands = ''
    mkfs.ext2 -F -L root /dev/disk/by-partlabel/root
  '';
}
