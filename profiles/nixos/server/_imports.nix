{ inputs, ... }:
{
  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-extra")
  ];
}
