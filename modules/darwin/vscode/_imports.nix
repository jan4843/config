{ inputs, ... }:
{
  homeConfig.imports = [ (inputs.self + "/modules/home/vscode") ];
}
