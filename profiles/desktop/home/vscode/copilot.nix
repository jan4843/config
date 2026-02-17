{ vscode-marketplace, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with vscode-marketplace; [
      github.copilot-chat
    ];

    userSettings = {
      "github.copilot.nextEditSuggestions.enabled" = true;
    };
  };
}
