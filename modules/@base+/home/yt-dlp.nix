{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
  ];

  home.shellAliases.dlp = lib.escapeShellArgs [
    "yt-dlp"
    "--format=bestvideo+bestaudio/best"
    "--compat-options=multistreams"
    "--embed-chapters"
    "--embed-subs"
  ];
}
