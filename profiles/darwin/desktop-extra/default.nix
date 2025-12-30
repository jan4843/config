{
  casks,
  inputs,
  lib,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/desktop-base")
  ];

  homeConfig.imports = [ (inputs.self + "/profiles/home/desktop-extra") ];

  ois.homebrew.casks = with casks; [
    appcleaner
    brave-browser
    firefox
    google-chrome
    hex-fiend
    imageoptim
    librewolf
    netnewswire
    pdf-squeezer
    proxyman
    rapidapi
    raspberry-pi-imager
    sf-symbols
    spotify
    suspicious-package
    utm
    tor-browser
  ];
}
