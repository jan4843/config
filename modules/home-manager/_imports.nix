{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      homeConfig.imports = [ inputs.self.homeModules.home-manager ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];
      homeConfig.imports = [ inputs.self.homeModules.home-manager ];
    };
}
