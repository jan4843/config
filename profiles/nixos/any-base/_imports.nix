{ inputs, ... }:
{
  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-base")
  ];
  imports = [
    (inputs.self + "/modules/nixos/home-manager")
    (inputs.self + "/modules/nixos/persistence")
    (inputs.self + "/modules/nixos/swap")
  ];
}
