{ inputs, ... }:
{
  networking.hostName = "sbc1";
  system.stateVersion = "24.11";

  imports = with inputs.self.nixosModules; [
    default

    compose
    docker
    persistence
    pi4
    ssh-server
    tailscale
  ];

  networking.firewall.enable = false;
  services.avahi.enable = true;
  zramSwap.enable = true;
}
