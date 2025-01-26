{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeProfiles; [
    asdf
    bash
    git
    gnu-utils
    go
    nix
    python
    ssh
    tree
    vim
    vscode
    wget
    yt-dlp

    alfred
    docker_darwin
    force-macbook-mic
    fork
    iina
    keyboard-maestro
    launchcontrol
    macos-settings
    middle
    monitorcontrol
    notunes
    skalacolor
    tailscale_darwin
    transmit
    trash
  ];

  home.packages = with pkgs; [
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

  self.homebrew.casks = [
    "homebrew/cask/appcleaner"
    "homebrew/cask/docker"
    "homebrew/cask/firefox"
    "homebrew/cask/google-chrome"
    "homebrew/cask/hex-fiend"
    "homebrew/cask/imageoptim"
    "homebrew/cask/librewolf"
    "homebrew/cask/netnewswire"
    "homebrew/cask/pdf-squeezer"
    "homebrew/cask/proxyman"
    "homebrew/cask/rapidapi"
    "homebrew/cask/raspberry-pi-imager"
    "homebrew/cask/sf-symbols"
    "homebrew/cask/spotify"
    "homebrew/cask/suspicious-package"
    "homebrew/cask/telegram"
    "homebrew/cask/utm"
    "homebrew/cask/whatsapp"
  ];

  self.backup = {
    enable = true;
    paths = [
      "${config.home.homeDirectory}/Documents"
      "${config.home.homeDirectory}/Developer"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };

  self.maestral.enable = true;
}
