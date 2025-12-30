{ inputs, ... }:
{
  imports = [
    (inputs.self + "/modules/home/home-manager")
    (inputs.self + "/modules/home/open-at-login")
    (inputs.self + "/modules/home/tcc")
  ];
}
