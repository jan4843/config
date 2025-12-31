{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix;

  _module.args.vscode-marketplace =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.userSettings = {
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "update.mode" = "none";
    };
  };

  home.sessionVariables = rec {
    EDITOR = lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };
}
