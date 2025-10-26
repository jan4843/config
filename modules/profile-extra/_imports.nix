{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.self.nixosModules.profile-base ];
      homeConfig.imports = [ inputs.self.homeModules.profile-extra ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = [ inputs.self.darwinModules.profile-base ];
      homeConfig.imports = [ inputs.self.homeModules.profile-extra ];
    };
}
