{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = with casks; [
        casks."logi-options+"

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
      ];
    };
}
