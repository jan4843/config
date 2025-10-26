{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.self.nixosModules.profiles.shared.base ];
      homeConfig.imports = [ inputs.self.homeModules.profiles.shared.extra ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = [ inputs.self.darwinModules.profiles.shared.base ];
      homeConfig.imports = [ inputs.self.homeModules.profiles.shared.extra ];
    };
}
