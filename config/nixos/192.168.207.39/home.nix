{ inputs, pkgs, ... }:
{
  imports = with inputs.self.homeModules; [
    bash
    gnu-utils
    ips
    nix
    tree
    vim
    wget
    yt-dlp
  ];

  home.packages = with pkgs; [
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
    watch
  ];
}
