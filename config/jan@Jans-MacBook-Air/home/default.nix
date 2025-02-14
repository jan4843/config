{ inputs, pkgs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
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
    ping
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
}
