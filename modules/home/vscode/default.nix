{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.vscode = {
    enable = true;

    keybindings = config.self.vscode.keybindings;
    userSettings = config.self.vscode.settings;
    globalSnippets = config.self.vscode.snippets.global;
    languageSnippets = config.self.vscode.snippets.languages;
    userTasks = {
      version = "2.0.0";
      inherit (config.self.vscode) tasks;
    };

    mutableExtensionsDir = false;
    extensions = map (
      name:
      lib.attrByPath (lib.strings.splitString "." name)
        (builtins.abort "vscode extension '${name}' not found")
        inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace
    ) config.self.vscode.extensions;
  };

  home.sessionVariables = rec {
    EDITOR = lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };
}
