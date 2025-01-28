{
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
