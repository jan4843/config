{ lib, pkgs, ... }:
let
  driversDir = "${pkgs.mesa.drivers}/share/vulkan/icd.d";
  drivers = lib.pipe driversDir [
    builtins.readDir
    builtins.attrNames
    (map (f: "${driversDir}/${f}"))
  ];
in
{
  self.steam-shortcuts.Chiaki = {
    script = ''
      LD_PRELOAD= \
      QT_XCB_GL_INTEGRATION=none \
      VK_ADD_DRIVER_FILES=${lib.concatStringsSep ":" drivers} \
      exec ${pkgs.chiaki-ng}/bin/chiaki
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/7ba1627465039d0e3b57d3febf27ee6c.png";
        hash = "sha256-SU4v2mSF0N7PhWny10bF0qN+7p9w6zG/T+l3Koy5BRo=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/c18d495840308d33a310af21ecbe9af7.png";
        hash = "sha256-vtZT2w9Kp6QgTgUDZmHapIp/6KK+JMxk1GJCzqRKeYs=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/0838b08289f1733d7753951451939454.png";
        hash = "sha256-wKYkvR7x3Ugw07VvlP7WDTIHmgCiDUD9yy+q1RteFIw=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/f39bd6151d360eb6be734461e33c9272.png";
        hash = "sha256-B2r1qWl7vSIRUXCdX3tfRuLowy3bPp6Ka8c2ErFIL1w=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/0e95227fcf854e423187696abca23a60.png";
        hash = "sha256-qAxiX/IdjO/SCJ8UaZHI98tcNlYlr8TqE8G2nzOUOUQ=";
      };
    };
  };
}
