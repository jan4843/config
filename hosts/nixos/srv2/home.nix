{ pkgs, ... }@args:
{
  homeConfig.home.stateVersion = "24.11";

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
    yt-dlp
  ];

  homeConfig.home.packages = with pkgs; [
    curlie
    file
    fswatch
    gnumake
    htop
    jq
    magic-wormhole
    mame-tools
    pdfgrep
    pv
    rsync
    unar
    usbutils
    watch
  ];
}
