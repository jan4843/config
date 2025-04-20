args: {
  imports = with args.inputs.self.nixosModules; [
    profile-lan
    profile-server

    qemu-guest
  ];
}
