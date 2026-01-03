{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    ../common/nix.nix
    ../common/nixpkgs.nix
    inputs.self.darwinModules.bash
    inputs.self.darwinModules.homebrew
    inputs.self.darwinModules.home-manager
  ];

  time.timeZone = "Europe/Vienna";
}
