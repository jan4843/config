args: {
  fileSystems = {
    "/".device = "/dev/disk/by-label/root";
    "/boot".device = "/dev/disk/by-label/boot";
    "/nix".device = "/dev/disk/by-label/nix";

    "/root" = {
      device = "${args.config.self.persistence.path}/root";
      options = [ "bind" ];
    };

    "/home" = {
      device = "${args.config.self.persistence.path}/home";
      options = [ "bind" ];
    };
  };

  boot.initrd.postDeviceCommands = ''
    waitDevice /dev/disk/by-partlabel/root
    mkfs.ext2 -F -L root /dev/disk/by-partlabel/root
  '';
}
