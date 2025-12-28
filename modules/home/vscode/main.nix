{ lib, ... }:
{
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
