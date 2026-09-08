{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    gh
  ];

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
