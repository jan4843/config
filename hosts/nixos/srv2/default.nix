args: {
  networking.hostName = "srv2";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  imports = with args.inputs.self.nixosModules; [
    default

    _srv
  ];
}
