{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    ../common/hostname.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    inputs.self.darwinModules.bash
    inputs.self.darwinModules.home-manager
  ];

  time.timeZone = "Europe/Vienna";
}
