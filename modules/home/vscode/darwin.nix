{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cask = builtins.readFile "${inputs.homebrew-cask}/Casks/v/visual-studio-code.rb";
  version = builtins.head (builtins.match ''.*:or_newer do[[:space:]]+version "([^"]+)".*'' cask);
in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  self.homebrew.casks = [ "visual-studio-code" ];

  programs.vscode.package = {
    type = "derivation";
    inherit (pkgs.vscode) pname;
    inherit version;
  };

  self.tcc = rec {
    DeveloperTool = [ "/Applications/Visual Studio Code.app" ];
    SystemPolicyAllFiles = DeveloperTool;
  };
}
