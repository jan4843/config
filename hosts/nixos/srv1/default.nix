{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profile-class-srv
  ];

  system.stateVersion = "24.11";
}
