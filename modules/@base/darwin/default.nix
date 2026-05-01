{ inputs, ... }:
{
  imports = [
    ../common/hostname.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    inputs.self.darwinModules.bash
    inputs.self.darwinModules.default
  ];

  time.timeZone = "Europe/Vienna";
}
