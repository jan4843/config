{ inputs, ... }:
{
  imports = [
    inputs.self.homeModules."@base"
  ];
}
