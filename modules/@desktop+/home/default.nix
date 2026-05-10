{ inputs, ... }:
{
  imports = [
    inputs.self.homeModules."@base+"
    inputs.self.homeModules."@desktop"
  ];

  self.homebrew.casks = [
    "appcleaner"
    "brave-browser"
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
    "utm"
    "tor-browser"
  ];

  self.mas = [
    409203825 # Numbers
  ];
}
