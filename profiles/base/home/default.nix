{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    ../common/nixpkgs.nix
    inputs.self.homeModules.home-manager
    inputs.self.homeModules.open-at-login
    inputs.self.homeModules.sudo-passwordless
    inputs.self.homeModules.tcc
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
