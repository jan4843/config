{ lib, pkgs, ... }:
{
  nix.package = lib.mkDefault pkgs.nix;

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
      "nix.serverPath" = lib.getExe pkgs.nil;
      "nix.serverSettings".nil = {
        formatting.command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
        nix.binary = "/run/current-system/sw/bin/nix";
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
