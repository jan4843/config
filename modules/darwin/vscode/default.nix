{
  casks,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix;

  homeConfig.imports = [ inputs.self.homeModules.vscode ];

  self.homebrew.casks = [ casks.visual-studio-code ];

  homeConfig = {
    programs.vscode.package = {
      type = "derivation";
      inherit (pkgs.vscode) pname version;
    };

    self.tcc = rec {
      DeveloperTool = [ "/Applications/Visual Studio Code.app" ];
      SystemPolicyAllFiles = DeveloperTool;
    };
  };
}
