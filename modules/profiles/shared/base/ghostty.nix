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
        custom-shader =
          let
            patch = {
              "-" = "DURATION = 0.3";
              "+" = "DURATION = 0.05";
            };
            original = rec {
              path = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/KroneCorylus/ghostty-shader-playground/2ec0f0386239a95b75a2e067e506d97c6c1b5336/public/shaders/cursor_smear.glsl";
                hash = "sha256-p/C4kClmqia+aIgiCdyBbdMVVmTkyzfH5rez85d3WYw=";
              };
              content = builtins.readFile path;
            };
            patched = rec {
              path = builtins.toFile "cursor-smear.glsl" content;
              content = builtins.replaceStrings [ patch."-" ] [ patch."+" ] original.content;
            };
          in
          patched.path;
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
