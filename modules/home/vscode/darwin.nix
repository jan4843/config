{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.hostPlatform.isDarwin {
  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    visual-studio-code
  ];

  programs.vscode.package = {
    type = "derivation";
    inherit (pkgs.vscode) pname version;
  };

  self.tcc.SystemPolicyAllFiles = [ "/Applications/Visual Studio Code.app" ];
}
