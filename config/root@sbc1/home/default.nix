{ inputs, pkgs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    gnu-utils
    ips
    nix
    push
    tree
    vim
    wget
  ];

  home.packages = with pkgs; [
    file
    htop
    lsscsi
    ncdu
    parted
    sg3_utils
    smartmontools
    unar
    usbutils
  ];
}
