{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    home-manager
    nix-darwin
  ];
}
