args:
let
  domain = args.config.networking.fqdn;
  site = "http://*.${domain}, https://*.${domain}";
  subsites = args.lib.pipe args.config.self.freeform.caddy.subsites [
    (builtins.mapAttrs (
      name: value: ''
        @${name} host ${name}.${domain}
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
  self.freeform.caddy = {
    subsites = { };
    sections.${site} = [
      ''
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          resolvers 1.1.1.1 1.0.0.1
        }

        ${subsites}
      ''
    ];
  };
}
