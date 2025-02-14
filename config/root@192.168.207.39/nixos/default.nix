{ inputs, ... }:
{
  networking.hostName = "vm";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  time.timeZone = "CET";
  zramSwap.enable = true;

  imports = with inputs.self.nixosModules; [
    default

    autoupgrade
    docker
    persistence
    qemu-guest
    ssh-server
    tailscale
  ];
}
