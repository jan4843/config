{ pkgs, ... }@args:
args.lib.mkIf pkgs.hostPlatform.isLinux {
  home.packages = with pkgs; [
    iptables
    lsscsi
    parted
    sg3_utils
    smartmontools
    usbutils
  ];
}
