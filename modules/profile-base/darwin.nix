{
  home-manager =
    {
      lib,
      pkgs,
      vscode-marketplace,
      ...
    }:
    lib.mkIf pkgs.hostPlatform.isDarwin {
      home.shellAliases = {
        zap = "brew uninstall --zap --force --cask";

        dnsflush = ''
          sudo dscacheutil -flushcache
          sudo killall -HUP mDNSResponder
        '';
      };

      programs.vscode.profiles.default.extensions = with vscode-marketplace; [
        dnicolson.binary-plist
      ];
    };
}
