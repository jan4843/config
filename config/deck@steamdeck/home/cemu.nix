{ config, pkgs, ... }:
{
  self.steam-shortcuts.CEMU = {
    script = ''
      LD_PRELOAD= \
      exec ${pkgs.self.vulkan-run}/bin/vulkan-run ${pkgs.cemu}/bin/cemu
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/86fb4d9e1de18ebdb6fc534de828d605.png";
        hash = "sha256-PoJBJa99Awf15bBSLQrciBL4AFMsNF+7TVc6Z0tQEwE=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/429f3ebdc9e3c2582ac685bc001b6262.png";
        hash = "sha256-hifqfNUYyEAmQaPsILX/VdluAtXra5aBA8faOPxujrY=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/6f611188ad4a81ffc2edab83b0705d76.jpg";
        hash = "sha256-kEMkcW07fR+30wvfnHyLeQ0g9MKlVtqzXr4mGUDPfE4=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/c7a9f13a6c0940277d46706c7ca32601.png";
        hash = "sha256-yxsnbeeN3QhjqSHHSkYqY77DcPa+hm//jendFwSFfBI=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/2480e640b88539a4256bd04b37bb8a29.png";
        hash = "sha256-C1QfzCmwCGBBpk+1MOUqsMx7iXg/HBBkeWUa715EaRc=";
      };
    };
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.config/Cemu"
    "${config.home.homeDirectory}/.local/share/Cemu/mlc01"
  ];
}
