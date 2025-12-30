{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  networking.firewall.enable = false;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
