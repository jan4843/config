{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  _module.args.vscode-marketplace =
    (pkgs.nix-vscode-extensions.forVSCodeVersion config.programs.vscode.package.version)
    .vscode-marketplace-release;

  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.userSettings = {
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = "off";
      "update.mode" = "none";
    };
  };

  home.sessionVariables = rec {
    EDITOR = lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };
}
