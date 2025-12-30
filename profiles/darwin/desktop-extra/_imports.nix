{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/darwin/desktop-base")
  ];
  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-extra")
  ];
}
