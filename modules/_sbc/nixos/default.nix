{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _lan
    _pi4
    _server
  ];

  self.swap.sizeGB = 4;
}
