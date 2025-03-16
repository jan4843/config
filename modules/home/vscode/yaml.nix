{ vscode-marketplace, ... }:
{
  programs.vscode = {
    extensions = with vscode-marketplace; [
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
