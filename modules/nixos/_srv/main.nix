args: {
  imports = with args.inputs.self.nixosModules; [
    _lan
    _server
    qemu-guest
  ];
}
