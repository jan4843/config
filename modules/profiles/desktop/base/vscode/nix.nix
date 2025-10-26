{
  home-manager =
    {
      lib,
      pkgs,
      vscode-marketplace,
      ...
    }:
    {
      programs.vscode.profiles.default = {
        extensions = with vscode-marketplace; [ jnoortheen.nix-ide ];

        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = lib.getExe pkgs.nil;
          "nix.serverSettings".nil = {
            formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
          };

          "[nix]" = {
            "editor.formatOnSave" = true;
            "editor.rulers" = [ 100 ];
          };

          "files.associations" = {
            "flake.lock" = "json";
          };
        };
      };
    };
}
