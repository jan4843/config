{ inputs, ... }:
{
  homeConfig.imports = [ inputs.self.homeModules.vscode ];
}
