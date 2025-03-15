{ pkgs, ... }@args:
{
  homeConfig.imports = with args.inputs.self.homeModules; [
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

  homeConfig.home.packages = with pkgs; [
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
