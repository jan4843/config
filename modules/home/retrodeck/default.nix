{ config, pkgs, ... }:
let
  retrodeck = pkgs.fetchFlatpak {
    refs = [
      "app/net.retrodeck.retrodeck/x86_64/stable@d0ca160265e691fb4813ec255c2ddfacbcc11751bea7466dbcc935a3a477a008"
      "runtime/org.kde.Platform/x86_64/6.7@87997f02ba47e4e9c70a29d5f80c57c932f07bb90583c92fa7ecd84b73921b0c"
      "runtime/net.retrodeck.retrodeck.Locale/x86_64/stable@fd881a1899aec2474f6af8a377eb0f2084f020a50091c82f95bcd54f88ff50c4"
      "runtime/org.freedesktop.Platform.ffmpeg-full/x86_64/23.08@3ef91fbf154edc8dbdd7f6130364f1c5fffd6e9ada42b9c81496a57a00fbcafc"
      "runtime/org.kde.Platform.Locale/x86_64/6.7@1ef98e72028ae58917b449f78eb8404d267b5c3ef4f8bb1a380fbf22573c20cc"
      "runtime/org.kde.KStyle.Adwaita/x86_64/6.7@f1b7398559fd8a7dde2a9ed85833cc0c5b75086c871e9f798143268952638ff4"
      "runtime/org.freedesktop.Platform.openh264/x86_64/2.2.0@bf24f23f3ba385f6e8c9215ed94d979db99814b0b614504a23a6d0751dc5f063"
      "runtime/org.freedesktop.Platform.GL.default/x86_64/23.08-extra@4ec382899342be0e2e83192b37e015f1742854bc7ebb9742ef4072a960c66755"
      "runtime/org.freedesktop.Platform.GL.default/x86_64/23.08@eb55a37807f391c514ec2621492a13c18d0a8fc9e4a1c38265e6e7f804ccc0e8"
    ];
    hash = "sha256-0XNEf40+ODmodbZyZvGy9fcgXOtNa3FtQaQz2L6ue6A=";
  };
in
{
  self.steam-shortcuts.RetroDECK = {
    script = "LD_PRELOAD= exec ${retrodeck}/bin/net.retrodeck.retrodeck";
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
