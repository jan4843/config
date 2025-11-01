{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profiles.desktop.base
        profiles.shared.extra
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.desktop.extra
      ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.darwinModules; [
        profiles.desktop.base
        profiles.shared.extra
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.desktop.extra
      ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profiles.desktop.base
        profiles.shared.extra
      ];
    };
}
