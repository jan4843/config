args: {
  self.freeform.caddy.plugins = [
    "github.com/mholt/caddy-dynamicdns@7c818ab3fc3485a72a346f85c77810725f19f9cf"
  ];

  self.freeform.caddy.config.ddns = ''
    dynamic_dns {
      provider cloudflare {env.CLOUDFLARE_API_TOKEN}
      ip_source ${args.config.self.freeform.caddy.ddns.ipSource}
      versions ipv4
      domains {
        ${args.config.networking.domain} *.${args.config.networking.hostName}
      }
    }
  '';
}
