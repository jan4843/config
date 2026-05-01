{ inputs, ... }:
{
  imports = [
    inputs.self.darwinModules."@base+"
    inputs.self.darwinModules."@desktop"
  ];
}
