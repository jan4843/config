{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.visual-studio-code ];
    };

  home-manager =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.hostPlatform.isDarwin {
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
