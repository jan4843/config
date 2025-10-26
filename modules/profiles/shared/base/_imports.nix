{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        home-manager
        persistence
        swap
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.shared.base
      ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.darwinModules; [
        inputs.nix-homebrew.darwinModules.homebrew
        home-manager
      ];
      homeConfig.imports = with inputs.self.homeModules; [
        profiles.shared.base
      ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        home-manager
        open-at-login
        tcc
      ];
    };
}
