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
  self.homebrew.casks = [ "ghostty@tip" ];

  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    package = pkgs.nixpkgs-unstable.ghostty;
  };

  xdg.configFile."ghostty/config".text = lib.generators.toINIWithGlobalSection {
    listsAsDuplicateKeys = true;
  } { globalSection = conf; };

  self.tcc = rec {
    DeveloperTool = [ "/Applications/Ghostty.app" ];
    SystemPolicyAllFiles = DeveloperTool;
  };
}
