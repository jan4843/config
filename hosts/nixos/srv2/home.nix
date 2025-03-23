args: {
  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base
    profile-extra

    bash
    nix
    push
  ];
}
