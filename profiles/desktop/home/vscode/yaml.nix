{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-marketplace; [
      redhat.vscode-yaml
    ];

    userSettings = {
      "[yaml]" = {
        "editor.tabSize" = 2;
      };

      "redhat.telemetry.enabled" = false;
    };
  };
}
