{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules."@lan"
    inputs.self.nixosModules."@pi4"
    inputs.self.nixosModules."@server"
  ];

  self.swap.sizeGB = 8;
}
