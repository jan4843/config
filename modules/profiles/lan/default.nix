{
  nixos = {
    networking.firewall.enable = false;

    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
