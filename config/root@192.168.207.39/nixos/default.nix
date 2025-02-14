{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    default

    autoupgrade
    lan
    persistence
    qemu-guest
    ssh-server
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.loader = {
    timeout = 1;
    generic-extlinux-compatible.configurationLimit = 8;
    systemd-boot.configurationLimit = 8;
  };

  time.timeZone = "CET";

  zramSwap.enable = true;
}
