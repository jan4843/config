{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop")
    (inputs.self + "/profiles/base+")
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
    "raspberry-pi-imager"
    "sf-symbols"
    "spotify"
    "suspicious-package"
    "utm"
    "tor-browser"
  ];

  self.mas = [
    409203825 # Numbers
    1573461917 # SponsorBlock
    6745342698 # uBlock Origin Lite
  ];
}
