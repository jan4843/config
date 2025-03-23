args: {
  self.freeform.caddy = {
    auth = args.lib.mkDefault false;
    sections."(default)" = args.lib.optional args.config.self.freeform.caddy.auth ''
      rate_limit {
        zone dynamic_example {
          key {remote_host}
          events 1000
          window 15m
        }
        log_key
      }

      basic_auth {
        {env.CADDY_AUTH_USERNAME} {env.CADDY_AUTH_PASSWORD}
      }
    '';
  };
}
