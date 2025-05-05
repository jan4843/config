args: {
  imports = with args.inputs.self.nixosModules; [
    profile-lan
    profile-server

    raspberry-pi-4
  ];
}
