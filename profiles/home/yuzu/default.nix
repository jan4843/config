{ pkgs, ... }:
let
  appimage = pkgs.fetchurl {
    url = "https://archive.org/download/yuzu_emulator_builds/yuzu/pineapple-src%20EA-4176/Linux-Yuzu-EA-4176.AppImage";
    hash = builtins.convertHash {
      hash = "md5:9f20b0e6bacd2eb9723637d078d463eb";
      toHashFormat = "sri";
    };
  };

  yuzu = pkgs.runCommand "yuzu" { } ''
    mkdir -p $out/bin
    cp ${appimage} $out/bin/Yuzu.AppImage
    chmod +x $_
  '';
in
{
  home.packages = [ yuzu ];
}
