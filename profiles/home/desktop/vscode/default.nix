{
  inputs,
  lib,
  vscode-marketplace,
  ...
}:
{

  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/modules/home/vscode")
  ];

  programs.vscode.profiles.default = {
    extensions = with vscode-marketplace; [
      dotjoshjohnson.xml
      ms-vscode.sublime-keybindings
    ];

    userSettings = {
      "chat.commandCenter.enabled" = false;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.accessibilitySupport" = "off";
      "editor.copyWithSyntaxHighlighting" = false;
      "editor.guides.bracketPairs" = "active";
      "editor.inlineSuggest.enabled" = true;
      "editor.lightbulb.enabled" = "off";
      "editor.minimap.showSlider" = "always";
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [ 80 ];
      "editor.stickyScroll.enabled" = true;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.ignoreRecommendations" = true;
      "files.insertFinalNewline" = true;
      "github.branchProtection" = false;
      "github.gitAuthentication" = false;
      "github.gitProtocol" = "ssh";
      "security.workspace.trust.enabled" = false;
      "security.workspace.trust.startupPrompt" = "never";
      "security.workspace.trust.untrustedFiles" = "open";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.scrollback" = 10000;
      "terminal.integrated.showExitAlert" = false;
      "update.showReleaseNotes" = false;
      "workbench.editor.empty.hint" = "hidden";
      "workbench.layoutControl.type" = "menu";
      "workbench.startupEditor" = "newUntitledFile";

      "[json]" = {
        "editor.formatOnPaste" = true;
      };

      "[markdown]" = {
        "editor.wordWrap" = "bounded";
      };

      "[ruby]" = {
        "editor.tabSize" = 2;
      };

      "[shellscript]" = {
        "editor.insertSpaces" = false;
      };
    };

    keybindings = [
      {
        key = "cmd+=";
        command = "editor.action.fontZoomIn";
      }
      {
        key = "cmd+-";
        command = "editor.action.fontZoomOut";
      }
      {
        key = "cmd+w";
        when = "!editorIsOpen";
        command = "workbench.action.closeWindow";
      }
      {
        key = "cmd+k";
        when = "terminalFocus";
        command = "workbench.action.terminal.clear";
      }
      {
        key = "shift+space";
        when = "terminalFocus";
        command = "workbench.action.terminal.sendSequence";
        args.text = "\u0002";
      }
      {
        key = "cmd+z";
        when = "terminalFocus";
        command = "workbench.action.terminal.sendSequence";
        args.text = "\u001f";
      }
    ];
  };
}
