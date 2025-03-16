{
  self.freeform.homebridge.compose.services.zigbee2mqtt = {
    devices = [
      {
        source = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20230218133714-if00";
        target = "/dev/ttyACM0";
        permissions = "rwm";
      }
    ];

    environment = {
      ZIGBEE2MQTT_CONFIG_SERIAL_ADAPTER = "ezsp";
      ZIGBEE2MQTT_CONFIG_SERIAL_PORT = "/dev/ttyACM0";
    };
  };
}
