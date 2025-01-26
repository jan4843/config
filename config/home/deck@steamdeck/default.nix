{ self, ... }:
{
  system = {
    platform = "x86_64-linux";
  };

  home = rec {
    user = "deck";
    directory = "/home/${user}";
    stateVersion = "24.11";
    modules = [
      self.homeModules.default
      ./home.nix
    ];
  };
}
