{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    autoupgrade
    qemu-guest
    ssh-server
  ];

  boot.loader = {
    timeout = 1;

    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;

    generic-extlinux-compatible.configurationLimit = 8;
    systemd-boot.configurationLimit = 8;
  };

  fileSystems = {
    "/".device = "/dev/disk/by-label/root";
    "/boot".device = "/dev/disk/by-label/boot";
    "/nix".device = "/dev/disk/by-label/nix";

    "/root" = {
      device = "/nix/persist/root";
      options = [ "bind" ];
    };
    "/home" = {
      device = "/nix/persist/home";
      options = [ "bind" ];
    };
  };

  boot.initrd.postDeviceCommands = ''
    mkfs.ext2 -F -L root /dev/disk/by-partlabel/root
  '';

  time.timeZone = "CET";

  zramSwap.enable = true;
}
