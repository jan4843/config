{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    _base
  ];
}
