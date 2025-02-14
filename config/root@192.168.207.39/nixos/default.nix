{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    default

    autoupgrade
    persistence
    qemu-guest
    ssh-server
    tailscale
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.loader = {
    timeout = 1;
    generic-extlinux-compatible.configurationLimit = 8;
    systemd-boot.configurationLimit = 8;
  };

  networking.firewall.enable = false;
  time.timeZone = "CET";
  zramSwap.enable = true;
}
