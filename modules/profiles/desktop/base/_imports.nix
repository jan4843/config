{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profiles.shared.base
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.desktop.base
      ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.darwinModules; [
        profiles.shared.base
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.desktop.base
      ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profiles.shared.base
      ];
    };
}
