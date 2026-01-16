{ inputs, pkgs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  systemd.user = {
    services.steam-grid = {
      Service = {
        Type = "oneshot";
        ExecStart = toString [
          "${(pkgs.python3.withPackages (p: [ p.vdf ]))}/bin/python"
          ./src/steam-autogrid.py
        ];
      };
    };

    timers.steam-grid = {
      Timer = {
        OnCalendar = "*:0";
        Unit = "steam-grid.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
