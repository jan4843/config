{ lib, pkgs, ... }:
let
  script = pkgs.writeScript "ping" ''
    #!/bin/sh
    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.curl
        pkgs.nettools
      ]
    }
    mkdir -p ~/.nix/ping
    touch ~/.nix/ping/key
    while :; do
      KEY=$(cat ~/.nix/ping/key)
      SLUG=$(hostname | tr '[:upper:]' '[:lower:]')
      curl \
        --silent \
        --output /dev/null \
        "https://hc-ping.com/$KEY/$SLUG"
      sleep 55
    done
  '';
in
{
  systemd.user.services.ping = {
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Restart = "always";
      ExecStart = script;
    };
  };

  launchd.agents.ping = {
    enable = true;
    config = {
      RunAtLoad = true;
      KeepAlive = true;
      ProgramArguments = [ "${script}" ];
    };
  };
}
