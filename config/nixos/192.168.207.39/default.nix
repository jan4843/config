{ self, ... }:
{
  system = {
    platform = "aarch64-linux";
    stateVersion = "24.11";
    modules = [
      self.nixosModules.default
      ./system.nix
    ];
  };

  home = {
    user = "root";
    directory = "/root";
    stateVersion = "24.11";
    modules = [
      self.homeModules.default
      ./home.nix
    ];
  };
}
