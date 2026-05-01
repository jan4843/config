{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules."@qemu-guest"
    inputs.self.nixosModules."@lan"
    inputs.self.nixosModules."@server"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
