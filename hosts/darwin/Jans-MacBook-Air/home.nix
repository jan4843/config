{ pkgs, ... }@args:
{
  homeConfig.home.stateVersion = "24.11";

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    alfred
    asdf
    bash
    darwin
    docker-darwin
    force-macbook-mic
    fork
    git
    gnu-utils
    go
    iina
    ips
    keyboard-maestro
    launchcontrol
    macos-settings
    maestral
    middle
    monitorcontrol
    nix
    notunes
    pdfdecrypt
    push
    python
    skalacolor
    ssh-client
    tailscale-darwin
    transmit
    trash
    tree
    vim
    vscode-config
    wget
    yt-dlp
  ];

  homeConfig.home.packages = with pkgs; [
    curl
    curlie
    file
    fswatch
    htop
    jq
    magic-wormhole
    pdfgrep
    pv
    rsync
    unar
    watch
  ];

  homeConfig.self.homebrew.casks = with args.casks; [
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
