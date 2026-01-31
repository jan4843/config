{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = config.lib.nixGL.wrap pkgs.cemu;
in
{
  home.packages = [ package ];

  self.steam-shortcuts.CEMU = {
    script = ''
      LD_PRELOAD= exec ${lib.getExe package}
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/33adf515b05df298e5834fea30d40ecb.png";
        hash = "sha256-47QBN8WcPIGDFApubUhMyy4AXHwl9CbPxXDC4AuDeas=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/298d97bf8b61a6603efdd17e4a5cb03b.png";
        hash = "sha256-aHCTo8S1e5t+u53B0hZr+0UvT0UVi74k4Jg8p+nUMWE=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/78dd46886c1d8fb577832eb8fbff11a3.png";
        hash = "sha256-iCTqkcSwsc8u4BgBOlDU0VJh4hKkviHJZ3UqPIRHWgw=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/67fe0f66449e31fdafdc3505c37d6acb.png";
        hash = "sha256-OzRre2ElBgwQUNjss+WLD9W6IZvvb0mEjthwF4sf6vI=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/9308b0d6e5898366a4a986bc33f3d3e7.ico";
        hash = "sha256-KBt49lMrqOnuBLK2dU34O93WJeJgMk5eTxWg9I0slGg=";
      };
    };
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.config/Cemu"
    "${config.home.homeDirectory}/.local/share/Cemu/mlc01"
  ];
}
