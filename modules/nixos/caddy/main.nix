args:
let
  version = "2.9.1";

  buildOpts = args.lib.pipe args.config.self.freeform.caddy.plugins [
    args.lib.naturalSort
    (map (x: "--with=${x}"))
    args.lib.escapeShellArgs
  ];

  config = args.lib.pipe args.config.self.freeform.caddy.config [
    builtins.attrValues
    args.lib.concatLines
  ];

  sites = args.lib.pipe args.config.self.freeform.caddy.sites [
    (builtins.mapAttrs (
      name: value: ''
        ${name} {
          log
          ${value}
        }
      ''
    ))
    builtins.attrValues
    args.lib.concatLines
  ];
in
{
  self.freeform.caddy.config.main = ''
    auto_https disable_redirects
  '';

  self.compose.projects.caddy = {
    services.caddy = {
      container_name = "caddy";
      pull_policy = "build";
      build.dockerfile_inline = ''
        FROM caddy:${version}-builder AS builder
        RUN xcaddy build ${buildOpts}
        FROM caddy:${version}
        COPY --from=builder /usr/bin/caddy /usr/bin/caddy
      '';

      restart = "unless-stopped";

      command = [
        "caddy"
        "run"
        "--config=/Caddyfile"
        "--envfile=/run/secrets/caddy"
      ];
      configs = [ "Caddyfile" ];

      network_mode = "host";

      healthcheck = {
        start_interval = "1s";
        start_period = "30s";
        test = ''
          wget \
            -T 30 \
            -O /dev/null \
            http://127.0.0.1
        '';
      };

      volumes = [
        {
          type = "bind";
          source = "${args.config.self.persistence.path}/caddy/certificates";
          target = "/data/caddy/certificates";
          bind.create_host_path = true;
        }
      ];

      secrets = [ "caddy" ];
    };

    secrets.caddy.file = "/nix/secrets/caddy";

    configs.Caddyfile.content = ''
      {
        ${config}
      }
      ${sites}
    '';
  };
}
