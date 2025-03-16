{ pkgs, ... }@args:
{
  _module.args.vscode-marketplace =
    args.inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace;
}
