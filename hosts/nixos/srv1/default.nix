args: {
  networking.hostName = "srv1";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  imports = with args.inputs.self.nixosModules; [
    default

    profile-srv
  ];
}
