{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    alfred-config
    asdf
    backup
    bash-config
    darwin
    docker-darwin
    force-macbook-mic
    fork
    git-config
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
    python
    skalacolor
    ssh-config
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

  self.backup = {
    paths = [
      "${config.home.homeDirectory}/Documents"
      "${config.home.homeDirectory}/Developer"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
    };
  };

  self.bash.functions.pdfdecrypt = ''
    (
      read -rsp "password: "
      for f in "$@"; do
        ${pkgs.qpdf}/bin/qpdf --decrypt --replace-input --password="$REPLY" "$f"
        rm -f "$f.~qpdf-orig"
      done
    )
  '';
}
