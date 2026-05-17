{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _base-extra
    _desktop
  ];
}
