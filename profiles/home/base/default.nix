{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/modules/home/home-manager")
    (inputs.self + "/modules/home/open-at-login")
    (inputs.self + "/modules/home/tcc")
  ];

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
