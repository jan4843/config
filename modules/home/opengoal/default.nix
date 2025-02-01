{ config, pkgs, ... }:
let
  flatpak = "dev.opengoal.OpenGOAL";
in
{
  self.flatpak.apps = [ flatpak ];

  self.steam-shortcuts.OpenGOAL = {
    script = ''
      exec flatpak --user run --filesystem="~/Games/OpenGOAL:create" ${flatpak}
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/1213a36483a7b4d67e1a7a09fc5e2e86.png";
        hash = "sha256-LWI8kZVt5ZYVuxv4koeqT9wk449Q2KFUyRqYNjqC7fo=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/5553c2408a9aa2ab9b5b10d576ac1b75.png";
        hash = "sha256-yF1vPv6ysugxl9dSOx6vF8VtEhqcERlZs7QEjs+UwYg=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/71e6912f7083de4e84dc2610d58b7734.png";
        hash = "sha256-ok9oPf9mIyVwp2+etbbVwBn7u/Ri0ZwawCeN+6zVntY=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/48503ae76db889fbde04dc3d052b02f7.png";
        hash = "sha256-m2fyUPecwEj2ByKEmq1XhAIcZUcg9Vber3VLyEzVU2w=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/48ecd78598456095d654c9196f973b00.png";
        hash = "sha256-IGX40ehScCENy4Qpn1hUWKA9ub6pLT8vUvLOTQFNpG8=";
      };
    };
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.var/app/dev.opengoal.OpenGOAL/config/OpenGOAL/*/saves"
  ];
}
