{ config, pkgs, ... }:
{
  self.steam-shortcuts.PCSX2 = {
    script = ''
      LD_PRELOAD= \
      exec ${pkgs.pcsx2}/bin/pcsx2-qt
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/2f67c2d9cb37755e9635edce68075b3c.jpg";
        hash = "sha256-jc/VMEvp3NdzPFQki8vfl3aleSKRpNB2YbpNrMfN6/I=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/8134c34f3560f99df6a1df2e19592b37.jpg";
        hash = "sha256-cYWD3BxCsq1Uh1ZqOD5/zMeqrwVTEr/Pp+OSDwX04Tc=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/18320ca6b79fbfcb9aa442e484885af6.png";
        hash = "sha256-9hO6rRFnBL+dKSkFr7vXUQhCs+hEkuDVQP2ulo4WrdY=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/cb9c528565c30d49b548831022bc9b32.png";
        hash = "sha256-hYBjpm3sEHsD4HkLk8SUpxz/GUpQ9NPh0YnOROSdJOE=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/9a32ff36c65e8ba30915a21b7bd76506.ico";
        hash = "sha256-6XqEVl2NuAnj1tgqENqRfDSsddpQHb81YOkTv+c3bBY=";
      };
    };
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.config/PCSX2/bios"
    "${config.home.homeDirectory}/.config/PCSX2/gamesettings"
    "${config.home.homeDirectory}/.config/PCSX2/inis"
    "${config.home.homeDirectory}/.config/PCSX2/inputprofiles"
    "${config.home.homeDirectory}/.config/PCSX2/memcards"
    "${config.home.homeDirectory}/.config/PCSX2/sstates"
  ];
}
