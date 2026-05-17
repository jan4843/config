{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.shellAliases = {
    zap = "brew uninstall --zap --force --cask";

    dnsflush = ''
      sudo dscacheutil -flushcache
      sudo killall -HUP mDNSResponder
    '';
  };
}
