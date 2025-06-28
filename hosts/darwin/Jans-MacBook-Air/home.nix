args:
let
  casks = args.config.homeConfig.self.homebrew.taps."homebrew/cask".casks;
in
{
  homeConfig.home.stateVersion = "24.11";

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base
    profile-extra

    alfred
    asdf
    bash
    darwin
    docker-darwin
    force-macbook-mic
    fork
    git
    go
    iina
    keyboard-maestro
    launchcontrol
    macos-settings
    maestral
    middle
    monitorcontrol
    nix
    notunes
    push
    python
    skalacolor
    ssh-client
    tailscale-darwin
    transmit
    vscode
  ];

  homeConfig.self.homebrew.casks = with casks; [
    casks."logi-options+"

    appcleaner
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
    telegram
    tor-browser
    utm
    whatsapp
  ];
}
