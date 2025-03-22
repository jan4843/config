{ pkgs, ... }:
{
  systemd.services.sonos-joiner = {
    requiredBy = [ "multi-user.target" ];
    path = [ (pkgs.python3.withPackages (ps: [ ps.soco ])) ];
    script = "python ${./_app/main.py}";
  };

  networking.firewall.enable = false;
}
