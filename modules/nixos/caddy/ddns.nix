let
  global = "";
in
args: {
  self.freeform.caddy = {
    ddns.ipSource = args.lib.mkAfter [
      "simple_http https://whatismyip.akamai.com"
      "simple_http https://checkip.amazonaws.com"
      "simple_http https://icanhazip.com"
      "simple_http https://api64.ipify.org"
    ];
    sections.${global} = [
      ''
        dynamic_dns {
          provider cloudflare {env.CLOUDFLARE_API_TOKEN}
          ${args.lib.concatMapStrings (x: ''
            ip_source ${x}
          '') args.config.self.freeform.caddy.ddns.ipSource}
          versions ipv4
          domains {
            ${args.config.networking.domain} ${args.config.networking.hostName} *.${args.config.networking.hostName}
          }
        }
      ''
    ];
  };
}
