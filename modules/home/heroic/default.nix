{ pkgs, ... }:
{
  self.steam-shortcuts.Heroic = {
    script = "LD_PRELOAD= ${pkgs.heroic-unwrapped}/bin/heroic";
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/726d04d0731a3930f3359dca8f721168.png";
        hash = "sha256-cQag7U5aRwsmXTv7hErK2vBJFzRirw0mossUg/+njHE=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/e022cb640ae8809689b66b0eb6464305.png";
        hash = "sha256-S5FmpmHLK7tp0ikBq4D8Si1VjdzrKhdDhH1SuIZeDzo=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/bace1d1361ca55cf11e8c50266678c52.png";
        hash = "sha256-vXlHUCMM83pSpv9XiCLAczUKpaqQhDdmCUJTv+1HqL8=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/f44d2854e944ac5223c15b2abdf57f38.png";
        hash = "sha256-GmofO40sFelawlZAbRqS4ERVxICDATA//1CIsE7D69A=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/9f73f765160d33280216b73b6378c068.png";
        hash = "sha256-e0bnimuhvNtGV0n26JK2IplpSsi97jVJzf6h4aNNQrc=";
      };
    };
  };
}
