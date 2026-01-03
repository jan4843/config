{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/base/nixos/nix.nix")
    (inputs.self + "/profiles/base/nixos/nixpkgs.nix")
    inputs.self.darwinModules.bash
    inputs.self.darwinModules.homebrew
    inputs.self.darwinModules.home-manager
  ];

  time.timeZone = "Europe/Vienna";
}
