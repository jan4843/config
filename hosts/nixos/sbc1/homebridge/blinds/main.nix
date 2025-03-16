{
  self.freeform.homebridge = {
    packages = {
      apt = [ "gpiod" ];
      npm = [ "homebridge-blinds-cmd@3.1.0" ];
    };

    config.platforms = [
      {
        platform = "Blinds Command";
        blinds = [
          {
            name = "Blinds";
            up = "sh -c 'gpioset 0 17=0; sleep 0.3; gpioset 0 17=1; echo 100'";
            down = "sh -c 'gpioset 0 27=0; sleep 0.3; gpioset 0 27=1; echo 0'";
            transitionInterval = 1;
          }
        ];
      }
    ];

    compose.services.homebridge.devices = [
      rec {
        source = "/dev/gpiochip0";
        target = source;
        permissions = "rwm";
      }
    ];
  };
}
