inputs: {
  inherit inputs;

  apps = import ./mkApps.nix inputs;
  packages = import ./mkPackages.nix inputs;

  nixosModules = import ./mkModules.nix inputs "nixos";
  darwinModules = import ./mkModules.nix inputs "darwin";
  homeModules = import ./mkModules.nix inputs "home";

  nixosConfigurations = import ./mkNixOS.nix inputs;
  darwinConfigurations = import ./mkDarwin.nix inputs;
  homeConfigurations = import ./mkHome.nix inputs;
}
