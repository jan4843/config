{ pkgs, ... }@args:
{
  programs.vscode = {
    extensions =
      with args.inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace; [
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
