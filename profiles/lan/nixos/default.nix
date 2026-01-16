{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  networking.firewall.enable = false;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
