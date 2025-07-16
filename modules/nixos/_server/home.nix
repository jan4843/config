args: {
  homeConfig.home.username = "root";

  imports = with args.inputs.self.nixosModules; [
    home-manager
  ];

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    _base
    _extra
    bash
    nix
    python
  ];
}
