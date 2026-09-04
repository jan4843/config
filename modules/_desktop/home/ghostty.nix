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

    # https://github.com/ghostty-org/ghostty/issues/10749
    keybind = [
      "super+v=paste_from_clipboard"
      "super+c=copy_to_clipboard"
    ];
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
