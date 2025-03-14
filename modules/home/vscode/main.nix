{ pkgs, ... }@args:
{
  programs.vscode = {
    enable = true;

    keybindings = args.config.self.vscode.keybindings;
    userSettings = args.config.self.vscode.settings;
    globalSnippets = args.config.self.vscode.snippets.global;
    languageSnippets = args.config.self.vscode.snippets.languages;
    userTasks = {
      version = "2.0.0";
      inherit (args.config.self.vscode) tasks;
    };

    mutableExtensionsDir = false;
    extensions = map (
      name:
      args.lib.attrByPath (args.lib.strings.splitString "." name)
        (builtins.abort "vscode extension '${name}' not found")
        args.inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace
    ) args.config.self.vscode.extensions;
  };

  home.sessionVariables = rec {
    EDITOR = args.lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };
}
