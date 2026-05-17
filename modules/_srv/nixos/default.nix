{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _qemu-guest
    _lan
    _server
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
