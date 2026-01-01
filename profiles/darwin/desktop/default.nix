{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/base")
    inputs.self.darwinModules.vscode
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/desktop")
  ];
}
