{
  imports = [
    ./accessibility.nix
    ./activity-monitor.nix
    ./calendar.nix
    ./disks.nix
    ./dock.nix
    ./documents.nix
    ./finder.nix
    ./keyboard.nix
    ./locale.nix
    ./mouse.nix
    ./safari.nix
    ./sound.nix
    ./textedit.nix
    ./trackpad.nix
    ./widgets.nix
    ./window-manager.nix
  ];

  home.shellAliases = {
    zap = "brew uninstall --zap --force --cask";
    dnsflush = ''
      sudo dscacheutil -flushcache
      sudo killall -HUP mDNSResponder
    '';
  };

  self.backup.exclude = [
    ".DS_Store"
    ".venv"
    "*.pyc"
    "node_modules/"
    "Pods/"
    "venv/"
  ];

  self.git.ignore = [ ".DS_Store" ];

  self.vscode.extensions = [ "dnicolson.binary-plist" ];
}
