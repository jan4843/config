{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/base/nix.nix")
    (inputs.self + "/profiles/nixos/base/nixpkgs.nix")
    inputs.self.darwinModules.bash
    inputs.self.darwinModules.homebrew
    inputs.self.darwinModules.home-manager
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/base")
  ];

  time.timeZone = "Europe/Vienna";
}
