{ pkgs, vscode-marketplace, ... }@args:
{
  nix.package = args.lib.mkDefault pkgs.nix;

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    show-trace = true;
    warn-dirty = false;
  };

  nix.gc.automatic = true;

  nixpkgs.config.allowUnfree = true;

  self.git.ignore = [ "/result" ];

  programs.vscode = {
    extensions = with vscode-marketplace; [
      jnoortheen.nix-ide
    ];

    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = args.lib.getExe pkgs.nil;
      "nix.serverSettings".nil = {
        formatting.command = [ (args.lib.getExe pkgs.nixfmt-rfc-style) ];
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
}
