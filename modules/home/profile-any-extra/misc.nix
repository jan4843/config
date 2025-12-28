{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      curlie
      magic-wormhole
      pdfgrep
      speedtest-go
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      bandwhich
      mame-tools
    ];
}
