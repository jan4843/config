{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
      github.copilot
      github.copilot-chat
    ];

    userSettings = {
      "github.copilot.nextEditSuggestions.enabled" = true;
    };
  };
}
