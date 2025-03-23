let
  global = "";
in
{
  self.freeform.caddy = {
    version = "2.9.1";
    plugins = [
      "github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece"
      "github.com/mholt/caddy-dynamicdns@7c818ab3fc3485a72a346f85c77810725f19f9cf"
      "github.com/mholt/caddy-ratelimit@v0.1.0"
    ];
    sections = {
      ${global} = [ "auto_https disable_redirects" ];
      "(default)" = [ "log" ];
    };
  };
}
