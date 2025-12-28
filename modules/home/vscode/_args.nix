{ inputs, pkgs, ... }:
{
  _module.args.vscode-marketplace =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
}
