{ vscode-marketplace, ... }:
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

  programs.vscode.extensions = with vscode-marketplace; [
    dnicolson.binary-plist
  ];
}
