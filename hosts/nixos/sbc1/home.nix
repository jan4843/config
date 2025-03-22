{ pkgs, ... }@args:
{
  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    bash
    gnu-utils
    ips
    lazydocker
    nix
    push
    python
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
