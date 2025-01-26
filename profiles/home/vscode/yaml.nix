{
  self.vscode = {
    extensions = [ "redhat.vscode-yaml" ];

    settings = {
      "[yaml]" = {
        "editor.tabSize" = 2;
      };

      "redhat.telemetry.enabled" = false;
    };
  };
}
