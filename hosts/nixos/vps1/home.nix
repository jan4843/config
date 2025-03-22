{ pkgs, ... }@args:
{
  imports = [ args.inputs.self.nixosModules.home-manager ];

  homeConfig.home.username = "root";

  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    bash
    gnu-utils
    ips
    nix
    push
    tree
    vim
    wget
    yt-dlp
  ];
}
