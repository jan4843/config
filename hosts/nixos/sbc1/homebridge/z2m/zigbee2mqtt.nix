args: {
  self.freeform.homebridge = {
    packages.npm = [ "homebridge-z2m@1.9.3" ];

    config.platforms = [
      {
        platform = "zigbee2mqtt";
        mqtt = {
          server = "mqtt://127.0.0.1:1883";
          base_topic = "zigbee2mqtt";
        };
      }
    ];

    compose = {
      services.zigbee2mqtt = {
        image = "ghcr.io/koenkk/zigbee2mqtt:1.36.0";

        restart = "unless-stopped";

        ports = [ "5277:8080" ];

        environment = {
          ZIGBEE2MQTT_CONFIG_ADVANCED_LOG_OUTPUT = builtins.toJSON [ "console" ];
          ZIGBEE2MQTT_CONFIG_FRONTEND = "true";
          ZIGBEE2MQTT_CONFIG_MQTT_SERVER = "mqtt://mosquitto:1883";
        };

        volumes = [
          {
            type = "bind";
            source = "${args.config.self.freeform.homebridge.dataDir}/zigbee2mqtt";
            target = "/app/data";
            bind.create_host_path = true;
          }
        ];

        healthcheck = {
          start_interval = "1s";
          start_period = "30s";
          test = ''
            wget \
              -T 30 \
              -O /dev/null \
              http://127.0.0.1:8080
          '';
        };

        depends_on.mosquitto.condition = "service_healthy";
      };

      services.homebridge.depends_on.zigbee2mqtt.condition = "service_healthy";
    };
  };
}
