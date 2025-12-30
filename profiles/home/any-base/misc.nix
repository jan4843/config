{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      curl
      file
      fswatch
      htop
      inetutils
      jq
      ncdu
      pv
      rclone
      rsync
      unar
      watch
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      dnsutils
      iptables
      lsscsi
      parted
      sg3_utils
      smartmontools
      usbutils
    ];
}
