{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      github.copilot-chat
    ];

    userSettings = {
      "github.copilot.nextEditSuggestions.enabled" = true;
    };
  };
}
