{ pkgs, ... }@args:
let
  script = pkgs.writeScript "push" ''
    #!/bin/sh
    export PATH=${
      args.lib.makeBinPath [
        pkgs.coreutils
        pkgs.curl
        pkgs.nettools
      ]
    }
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
  systemd.user.services.push = {
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Restart = "always";
      ExecStart = script;
    };
  };

  launchd.agents.push = {
    enable = true;
    config = {
      RunAtLoad = true;
      KeepAlive = true;
      ProgramArguments = [ "${script}" ];
    };
  };
}
