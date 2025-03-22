{ pkgs, ... }@args:
let
  helper = ".local/nix/push";

  path = with pkgs; [
    coreutils
    curl
    nettools
  ];
  script = pkgs.writeShellScript "push" ''
    export PATH=${args.lib.makeBinPath path}
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    while :; do
      KEY=$(cat /nix/secrets/push.key)
      SLUG=$(hostname | tr '[:upper:]' '[:lower:]')
      curl \
        --silent \
        --output /dev/null \
        "https://hc-ping.com/$KEY/$SLUG?create=1"
      sleep 55
    done
  '';
in
{
  home.file.${helper}.source = script;

  systemd.user.services.push = {
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Restart = "always";
      ExecStart = "${args.config.home.homeDirectory}/${helper}";
    };
  };

  launchd.agents.push = {
    enable = true;
    config = {
      RunAtLoad = true;
      KeepAlive = true;
      ProgramArguments = [ "${args.config.home.homeDirectory}/${helper}" ];
    };
  };
}
