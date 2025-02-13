{ lib, pkgs, ... }:
lib.mkIf pkgs.hostPlatform.isDarwin {
  self.homebrew.casks = [ "homebrew/cask/visual-studio-code" ];
  programs.vscode.package = {
    type = "derivation";
    inherit (pkgs.vscode) pname version;
  };

  self.tcc.SystemPolicyAllFiles = [ "/Applications/Visual Studio Code.app" ];
}
