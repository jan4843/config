args:
let
  buildOpts = args.lib.pipe args.config.self.freeform.caddy.plugins [
    args.lib.naturalSort
    args.lib.unique
    (map (x: "--with=${x}"))
    args.lib.escapeShellArgs
  ];
in
{
  self.compose.projects.caddy = {
    services.caddy = {
      container_name = "caddy";

      pull_policy = "build";
      build.dockerfile_inline = ''
        FROM caddy:${args.config.self.freeform.caddy.version}-builder AS builder
        RUN xcaddy build ${buildOpts}
        FROM caddy:${args.config.self.freeform.caddy.version}
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

    configs.Caddyfile.content = args.lib.pipe args.config.self.freeform.caddy.sections [
      (builtins.mapAttrs (
        name: value: ''
          ${name} {
            ${args.lib.optionalString (name != "" && !args.lib.hasPrefix "(" name) "import default"}
            ${args.lib.concatLines value}
          }
        ''
      ))
      builtins.attrValues
      args.lib.concatLines
    ];
  };
}
