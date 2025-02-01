{ config, pkgs, ... }:
{
  self.flatpak.apps = [ "net.retrodeck.retrodeck" ];

  self.steam-shortcuts.RetroDECK = {
    script = ''
      exec flatpak --user run net.retrodeck.retrodeck
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/c21ceff81f372048509914fdf9ee4804.png";
        hash = "sha256-BnO5HytFpOF1m/0QGVVGrdjB/wVIkb1cng66HnJHhko=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/547c3d9fadf02d639f3781c7278832cb.png";
        hash = "sha256-VUYcKyLRo67JozsQ7dwNYvkIato3J2vxencucd2R7Lk=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/f02544155742fe7bd2acdbefb5377558.png";
        hash = "sha256-y24xDSCoMQN8rQZO2oLMk58DPjJl3FkfuMxdrfTqI8I=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/302d81c382f64c3ef4866c87da8711c6.png";
        hash = "sha256-yhBO5VVQ8JwRkE0Vq/HIDAogI+l8ORBMHWjXZDTk8Z8=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/30053752ef1262ce2cc6cea7d4f6e41a.ico";
        hash = "sha256-R9z9UPMRfKwsdU4EAyNSuEJh16eiyD+o4p+QuGg4i8Q=";
      };
    };
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/retrodeck/saves"
    "${config.home.homeDirectory}/retrodeck/states"
  ];
}
