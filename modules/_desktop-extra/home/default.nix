{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    _base-extra
    _desktop
  ];

  self.homebrew.casks = [
    "appcleaner"
    "firefox"
    "google-chrome"
    "hex-fiend"
    "imageoptim"
    "librewolf"
    "netnewswire"
    "pdf-squeezer"
    "proxyman"
    "rapidapi"
    "sf-symbols"
    "spotify"
    "suspicious-package"
    "tor-browser"
    "utm"
  ];

  self.mas = [
    409203825 # Numbers
  ];
}
