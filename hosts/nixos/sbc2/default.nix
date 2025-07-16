args: {
  networking.hostName = "sbc2";
  system.stateVersion = "24.11";

  imports = with args.inputs.self.nixosModules; [
    default

    _sbc
  ];
}
