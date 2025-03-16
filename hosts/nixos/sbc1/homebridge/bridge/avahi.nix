{
  services.avahi = {
    enable = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  self.freeform.homebridge = {
    config.bridge = {
      port = 51826;
      advertiser = "avahi";
    };

    compose.services.homebridge = {
      volumes = [
        rec {
          type = "bind";
          source = "/var/run/dbus";
          target = source;
        }
        rec {
          type = "bind";
          source = "/var/run/avahi-daemon/socket";
          target = source;
        }
      ];
    };
  };
}
