{
  home-manager =
    { lib, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          curl
          file
          fswatch
          htop
          jq
          ncdu
          pv
          rclone
          rsync
          unar
          watch
        ]
        ++ lib.optionals pkgs.hostPlatform.isLinux [
          dnsutils
          iptables
          lsscsi
          parted
          sg3_utils
          smartmontools
          usbutils
        ];
    };
}
