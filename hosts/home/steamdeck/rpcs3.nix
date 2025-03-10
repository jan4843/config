{ pkgs, ... }:
{
  self.steam-shortcuts.RPCS3 = {
    script = ''
      LD_PRELOAD= \
      exec ${pkgs.rpcs3}/bin/rpcs3
    '';
    assets = {
      grid.horizontal = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/0adca75877497f1ea978a22eac31356c.png";
        hash = "sha256-tg2gSkJVAgrsCoSyjBgp8XXNbCBX4jBVy03K8YoBMBk=";
      };
      grid.vertical = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/grid/4c7fa69fcd7e19bb58fa3030586d5958.png";
        hash = "sha256-6qF3Wjwd2zazLyKN+lTxo6daVRCnkYgfAU4e+IO1Mxw=";
      };
      hero = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/hero/b1043fc9fa760359c5f79a4efcb181fa.png";
        hash = "sha256-8BcyVOzCBeUv2vndQ/wyo7KePzf+TPedWsD40X7NeTI=";
      };
      logo = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/logo/bffc98347ee35b3ead06728d6f073c68.png";
        hash = "sha256-Ft8qsADNdEfAzVDPfjFjMvl6Bkmz7tXso6qbA7/F6OM=";
      };
      icon = pkgs.fetchurl {
        url = "https://cdn2.steamgriddb.com/icon/add5aebfcb33a2206b6497d53bc4f309.ico";
        hash = "sha256-9v9BNGlzj4XR8zOdiRGzsirrxJbCp1tnfqv8uXAIOk4=";
      };
    };
  };
}
