args: {
  self.freeform.homebridge.compose = {
    configs.homebridge.content = builtins.toJSON args.config.self.freeform.homebridge.config;

    services.homebridge.configs = [
      {
        source = "homebridge";
        target = "/data/config.json";
      }
    ];
  };
}
