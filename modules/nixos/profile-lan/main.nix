{
  networking.firewall.enable = false;

  services.avahi = {
    enable = true;
    publish.enable = true;
  };
}
