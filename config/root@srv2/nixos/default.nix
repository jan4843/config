{ inputs, ... }:
{
  networking.hostName = "srv2";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  time.timeZone = "CET";
  zramSwap.enable = true;

  imports = with inputs.self.nixosModules; [
    default

    autoupgrade
    compose
    docker
    persistence
    qemu-guest
    ssh-server
    tailscale
  ];
}
