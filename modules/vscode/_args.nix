rec {
  nixos = home-manager;

  nix-darwin = home-manager;

  home-manager =
    { inputs, pkgs, ... }:
    {
      _module.args.vscode-marketplace =
        inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace;
    };
}
