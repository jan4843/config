{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  self.homebrew.casks = [ "visual-studio-code" ];

  programs.vscode.package = {
    type = "derivation";
    inherit (pkgs.vscode) pname version;
  };

  self.tcc = rec {
    DeveloperTool = [ "/Applications/Visual Studio Code.app" ];
    SystemPolicyAllFiles = DeveloperTool;
  };
}
