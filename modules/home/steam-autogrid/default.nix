{ inputs, pkgs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  systemd.user = {
    services.steam-autogrid = {
      Service = {
        Type = "oneshot";
        ExecStart = toString [
          "${(pkgs.python3.withPackages (p: [ p.vdf ]))}/bin/python"
          ./src/steam-autogrid.py
        ];
      };
    };

    timers.steam-autogrid = {
      Timer = {
        OnCalendar = "*:0";
        Unit = "steam-autogrid.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
