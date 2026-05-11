{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = [
      pkgs.vscode-extensions.anthropic.claude-code
    ];

    userSettings = {
      "claudeCode.hideOnboarding" = true;
      "claudeCode.preferredLocation" = "sidebar";
    };
  };
}
