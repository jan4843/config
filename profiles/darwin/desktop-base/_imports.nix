{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/darwin/any-base")
    (inputs.self + "/modules/darwin/vscode")
  ];
  homeConfig.imports = [
    (inputs.self + "/profiles/home/desktop-base")
  ];
}
