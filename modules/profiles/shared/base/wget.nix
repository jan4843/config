{
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wget ];

      home.file.".wgetrc".text = ''
        content_disposition=on
        continue=on
        dns_cache=off
        hsts-file=/dev/null
      '';
    };
}
