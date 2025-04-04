{ pkgs, ... }@args:
let
  pkgs' = {
    mkCaddy = pkgs.callPackage ./_pkgs/mkCaddy.nix { };
    mkCaddyfile = pkgs.callPackage ./_pkgs/mkCaddyfile.nix { caddy = pkgs'.caddy; };
    caddy = pkgs'.mkCaddy {
      modules = [
        # https://pkg.go.dev/github.com/caddyserver/caddy/v2?tab=versions
        "github.com/caddyserver/caddy/v2@v2.9.1"
        # https://pkg.go.dev/github.com/caddy-dns/cloudflare?tab=versions
        "github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de"
        # https://pkg.go.dev/github.com/mholt/caddy-dynamicdns?tab=versions
        "github.com/mholt/caddy-dynamicdns@v0.0.0-20241025234131-7c818ab3fc34"
      ];
      modulesHash = "sha256-gEGYqI5Ur1fcFYGAXteUsooDoRt4d4QybEiVAzssPrI=";
    };
  };

  sites = args.lib.pipe args.config.self.caddy.sites [
    (args.lib.filterAttrs (name: _: args.lib.hasInfix ":" name))
    (builtins.mapAttrs (
      name: value: ''
        ${name} {
          import default
          ${value}
        }
      ''
    ))
    builtins.attrValues
    args.lib.concatLines
  ];

  subsites = args.lib.pipe args.config.self.caddy.sites [
    (args.lib.filterAttrs (name: _: !args.lib.hasInfix ":" name))
    (builtins.mapAttrs (
      name: value: ''
        @${name} host ${name}.${args.config.networking.fqdn}
        handle @${name} {
          ${value}
        }
      ''
    ))
    builtins.attrValues
    args.lib.concatLines
  ];
in
{
  environment.etc."caddy/Caddyfile".source = pkgs'.mkCaddyfile ''
    {
      auto_https disable_redirects

      dynamic_dns {
        provider cloudflare {env.CLOUDFLARE_API_TOKEN}
        ip_source interface tailscale0
        versions ipv4
        domains {
          ${args.config.networking.domain} ${args.config.networking.hostName} *.${args.config.networking.hostName}
        }
      }
    }

    (default) {
      log
    }

    ${sites}

    http://*.${args.config.networking.fqdn}, https://*.${args.config.networking.fqdn} {
      import default

      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        resolvers 1.1.1.1 1.0.0.1
      }

      ${subsites}
    }
  '';

  systemd.services.caddy = {
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    reloadTriggers = [ args.config.environment.etc."caddy/Caddyfile".source ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs'.caddy}/bin/caddy run --config=/etc/caddy/Caddyfile --envfile=/nix/secrets/caddy";
      ExecReload = "${pkgs'.caddy}/bin/caddy reload --config=/etc/caddy/Caddyfile --force";
      RuntimeDirectory = "caddy";
    };
    environment = {
      HOME = "/run/caddy";
      XDG_DATA_HOME = args.config.self.persistence.path;
    };
  };
}
