{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curlie
    magic-wormhole
    pdfgrep
  ];
}
