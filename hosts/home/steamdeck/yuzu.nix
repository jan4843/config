{ pkgs, ... }@args:
let
  pkgs' = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/78add7b7abb61689e34fc23070a8f55e1d26185b.tar.gz";
    sha256 = "07gxwsywvlsnqj87g9r60j8hrvydcy0sa60825pzkdilrwwhnwjx";
  }) { system = pkgs.hostPlatform.system; };
in
{
  self.steam-shortcuts.Yuzu = {
    script = ''
      LD_PRELOAD= \
      QT_XCB_GL_INTEGRATION=none \
      exec ${pkgs'.torzu}/bin/yuzu
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/07329c52f7966a5d9cd3a0c148da52aa.png";
        hash = "sha256-Ml7s69yuvJi4ef4jx17G4+QI1HL7bcwmQvgh9A1+8k8=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/68079592185f8b33654ea2a39014e488.png";
        hash = "sha256-4uECAVeXXz2qZu9pKd/AQ+DO8HTgpb3d2OOsmuA/5bk=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/43e416338d443d17de7545ccaae9b9e4.png";
        hash = "sha256-tds5W47jhRu3fylUC7U5FtzVTZS0QXqO4+5cb0RaIaA=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/b93528eac380cde3590c4018cd8a10f5.png";
        hash = "sha256-HP33YPbh4l8EZq7KsYtJ7DiRTpgeJOsukTRBknFq+UI=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/2cfa3753d6a524711acb5fce38eeca1a.ico";
        hash = "sha256-o8ZjLgrn9mmruzkGNvfMRdh57wbbQwAexm+UV6wq0xM=";
      };
    };
  };

  self.backup.paths = [
    "${args.config.home.homeDirectory}/.config/yuzu"
    "${args.config.home.homeDirectory}/.local/share/yuzu/keys"
    "${args.config.home.homeDirectory}/.local/share/yuzu/load" # mods
    "${args.config.home.homeDirectory}/.local/share/yuzu/nand"
    "${args.config.home.homeDirectory}/.local/share/yuzu/sdmc"
  ];
}
