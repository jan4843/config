{ pkgs, ... }@args:
args.lib.mkIf pkgs.hostPlatform.isLinux {
  home.packages = with pkgs; [
    mame-tools
  ];
}
