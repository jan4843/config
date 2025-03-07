{ inputs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    gnu-utils
    ips
    nix
    tree
    vim
    wget
  ];
}
