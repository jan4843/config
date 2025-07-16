args:
let
  GB = 1024;
in
{
  imports = with args.inputs.self.nixosModules; [
    _lan
    _server
    raspberry-pi-4
  ];

  swapDevices = [
    {
      device = "/nix/swapfile";
      size = 4 * GB;
    }
  ];
}
