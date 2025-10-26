{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profile-base
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profile-desktop-base
      ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.darwinModules; [
        profile-base
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profile-desktop-base
      ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profile-base
      ];
    };
}
