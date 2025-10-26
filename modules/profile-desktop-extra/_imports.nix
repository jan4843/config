{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profile-desktop-base
        profile-extra
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profile-desktop-extra
      ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.darwinModules; [
        profile-desktop-base
        profile-extra
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profile-desktop-extra
      ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profile-desktop-base
        profile-extra
      ];
    };
}
