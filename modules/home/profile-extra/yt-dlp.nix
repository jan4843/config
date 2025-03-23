{ pkgs, ... }@args:
{
  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
  ];

  home.shellAliases.dlp = args.lib.strings.escapeShellArgs [
    "yt-dlp"
    "--format=bestvideo+bestaudio/best"
    "--compat-options=multistreams"
    "--embed-chapters"
    "--embed-subs"
  ];
}
