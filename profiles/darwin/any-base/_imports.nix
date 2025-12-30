{ inputs, ... }:
{
  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-base")
  ];
  imports = [
    (inputs.self + "/modules/darwin/bash")
    (inputs.self + "/modules/darwin/homebrew")
    (inputs.self + "/modules/darwin/home-manager")
  ];
}
