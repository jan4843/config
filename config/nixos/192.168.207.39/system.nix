{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
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

  boot.postBootCommands = "ln -sfn ${inputs.self} /run/booted-config";
  systemd.tmpfiles.rules = [ "L+ /run/current-config - - - - ${inputs.self}" ];

  time.timeZone = "CET";

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "${inputs.self}";
  };

  zramSwap.enable = true;
}
