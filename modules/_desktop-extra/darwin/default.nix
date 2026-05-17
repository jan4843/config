{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    _base-extra
    _desktop
  ];
}
