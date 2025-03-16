{
  self.freeform.homebridge.compose = {
    services.mosquitto = {
      container_name = "mosquitto";

      image = "eclipse-mosquitto:2.0.18";
      restart = "unless-stopped";
      ports = [ "127.0.0.1:1883:1883" ];

      healthcheck = {
        start_interval = "1s";
        start_period = "30s";
        test = ''
          mosquitto_sub \
            -E \
            -t '$SYS/#' \
            -W 30
        '';
      };

      configs = [
        {
          source = "mosquitto";
          target = "/mosquitto/config/mosquitto.conf";
        }
      ];
    };

    configs.mosquitto.content = ''
      allow_anonymous true
      listener 1883 0.0.0.0
    '';
  };
}
