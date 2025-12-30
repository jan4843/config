{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/any-base")
    (inputs.self + "/modules/darwin/vscode")
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/desktop-base")
  ];
}
