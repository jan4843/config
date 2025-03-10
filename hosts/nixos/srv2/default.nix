{ inputs, pkgs, ... }:
{
  networking.hostName = "srv2";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  time.timeZone = "CET";
  zramSwap.enable = true;

  imports = with inputs.self.nixosModules; [
    default

    compose
    docker
    home-manager
    persistence
    qemu-guest
    ssh-server
    tailscale
  ];

  hardware.firmware = with pkgs; [
    linux-firmware
    libreelec-dvb-firmware
  ];
  nixpkgs.config.allowUnfree = true;
}
