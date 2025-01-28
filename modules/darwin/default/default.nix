{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    bash
    home-manager
    nix-darwin
  ];
}
