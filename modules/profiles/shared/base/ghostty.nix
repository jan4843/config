{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks."ghostty@tip" ];
    };

  home-manager =
    { lib, pkgs, ... }:
    let
      mb = 1024 * 1024;
      conf = {
        font-feature = [
          "-calt"
          "-liga"
          "-dlig"
        ];
        shell-integration-features = "no-cursor";
        cursor-style-blink = false;
        scrollback-limit = 128 * mb;
      };
    in
    {
      home.packages = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.ghostty.terminfo;

      programs.ghostty.enable = pkgs.stdenv.hostPlatform.isLinux;

      xdg.configFile."ghostty/config".text = lib.generators.toINIWithGlobalSection {
        listsAsDuplicateKeys = true;
      } { globalSection = conf; };

      self.tcc = rec {
        DeveloperTool = [ "/Applications/Ghostty.app" ];
        SystemPolicyAllFiles = DeveloperTool;
      };
    };
}
