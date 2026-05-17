{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _base
  ];
}
