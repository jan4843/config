args: {
  networking.hostName = "sbc1";
  system.stateVersion = "24.11";

  imports = with args.inputs.self.nixosModules; [
    default

    profile-sbc
  ];
}
