{ pkgs, vscode-marketplace, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [
      vscode-marketplace.github.copilot-chat or pkgs.vscode-extensions.github.copilot-chat
    ];

    userSettings = {
      "github.copilot.nextEditSuggestions.enabled" = true;
    };
  };
}
