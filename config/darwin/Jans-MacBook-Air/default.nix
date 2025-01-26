{ self, ... }:
{
  system = {
    platform = "aarch64-darwin";
    stateVersion = 5;
    modules = [
      self.darwinModules.default
      ./system.nix
    ];
  };

  home = rec {
    user = "jan";
    directory = "/Users/${user}";
    stateVersion = "24.11";
    modules = [
      self.homeModules.default
      ./home.nix
    ];
  };
}
