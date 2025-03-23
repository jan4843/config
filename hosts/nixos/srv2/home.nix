{ pkgs, ... }@args:
{
  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base

    bash
    nix
    push
    yt-dlp
  ];

  homeConfig.home.packages = with pkgs; [
    curlie
    magic-wormhole
    mame-tools
    pdfgrep
    usbutils
  ];
}
