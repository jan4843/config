args: {
  imports = [ args.inputs.self.nixosModules.home-manager ];

  homeConfig.home.username = "root";

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base

    bash
    nix
    push
    yt-dlp
  ];
}
