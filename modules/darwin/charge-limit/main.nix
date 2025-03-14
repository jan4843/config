{ pkgs, ... }:
let
  maxPercentage = 70;
in
{
  launchd.daemons.charge-limit = {
    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 5 * 60;
    };

    path = [
      pkgs.gnugrep
      (pkgs.callPackage ./files/smc.nix { })
    ];

    script = ''
      battery_percentage=$(
        /usr/bin/pmset -g batt |
        grep -Eo '[0-9]+%' | grep -Eo '[0-9]+'
      )
      if [ "$battery_percentage" -lt ${toString maxPercentage} ] || [ -e /tmp/allow-charging ]; then
        smc -k CH0C -w 00
      else
        smc -k CH0C -w 01
      fi
    '';
  };
}
