{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks."ghostty@tip" ];
    };

  home-manager =
    { lib, pkgs, ... }:
    let
      conf = {
        font-feature = [
          "-calt"
          "-liga"
          "-dlig"
        ];
        shell-integration-features = "no-cursor";
        cursor-style-blink = false;
      };
    in
    {
      home.packages = lib.mkIf pkgs.hostPlatform.isLinux [ pkgs.ghostty ];

      xdg.configFile."ghostty/config".text = lib.generators.toINIWithGlobalSection {
        listsAsDuplicateKeys = true;
      } { globalSection = conf; };
    };
}
