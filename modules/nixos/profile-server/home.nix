args: {
  homeConfig.home.username = "root";

  imports = with args.inputs.self.nixosModules; [
    home-manager
  ];

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base
    profile-extra

    bash
    nix
    push
    python
  ];
}
