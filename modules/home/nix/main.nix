{ pkgs, ... }@args:
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

  self.vscode = {
    extensions = [ "jnoortheen.nix-ide" ];

    settings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = args.lib.getExe pkgs.nil;
      "nix.serverSettings".nil = {
        formatting.command = [ (args.lib.getExe pkgs.nixfmt-rfc-style) ];
      };

      "[nix]" = {
        "editor.formatOnSave" = true;
      };

      "files.associations" = {
        "flake.lock" = "json";
      };
    };
  };
}
