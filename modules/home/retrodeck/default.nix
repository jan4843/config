{ config, pkgs, ... }:
let
  retrodeck = pkgs.self.fetchFlatpak {
    refs = [
      "app/net.retrodeck.retrodeck/x86_64/stable@4bce48e1a51baae9013f50bace61d600b5df6eb999eb6b3e2f00d79d5f25aebe"
      "runtime/org.kde.Platform/x86_64/6.5@9fa4355a807109a061ce727f18a51128f8eb61e4c097f5e7e58cf1162d08b755"
      "runtime/org.kde.Platform.Locale/x86_64/6.5@3af3820a32090dfb4941a9c1d03e65e8610dbffb94152c5d4ee9dffd87daa3e5"
      "runtime/org.kde.KStyle.Adwaita/x86_64/6.5@598a394874266d95b745070852df7e935d32889387027976c8f11b6aa00efba1"
      "runtime/org.freedesktop.Platform.openh264/x86_64/2.2.0@bf24f23f3ba385f6e8c9215ed94d979db99814b0b614504a23a6d0751dc5f063"
      "runtime/org.freedesktop.Platform.GL.default/x86_64/22.08-extra@10fc92ea465df41fec2471f0dda7f60d4f8a55beac9fc9f9cbe17d186a83cf7b"
      "runtime/org.freedesktop.Platform.GL.default/x86_64/22.08@db524dc0f1a0befee753e243a7905dc359a473eb118fdbfe4d175609b31d6765"
    ];
    hash = "sha256-/FuG0YvKjIHY49SzBq2cnfM32mq1aNWderoKRPM+Ri8=";
  };
in
{
  self.steam-shortcuts.RetroDECK = {
    script = ''
      export LD_PRELOAD=
      ${pkgs.coreutils}/bin/mkdir -p ~/Games/RetroDECK/var &&
      exec ${pkgs.bubblewrap}/bin/bwrap \
        --dev-bind / / \
        --tmpfs ~ \
        --bind ~/Games/RetroDECK ~/retrodeck \
        --bind ~/Games/RetroDECK/var ~/.var/app/net.retrodeck.retrodeck \
        ${retrodeck}/bin/net.retrodeck.retrodeck
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
    "${config.home.homeDirectory}/Games/RetroDECK/saves"
    "${config.home.homeDirectory}/Games/RetroDECK/states"
  ];
}
