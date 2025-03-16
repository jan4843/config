{
  self.freeform.homebridge = {
    packages.apt = [ "mdns-scan" ];

    compose.services.homebridge = {
      network_mode = "host";

      healthcheck = {
        start_interval = "1s";
        start_period = "30s";
        test = ''
          timeout 30 \
          mdns-scan 2>&1 |
          grep -m1 -F Homebridge
        '';
      };
    };
  };
}
