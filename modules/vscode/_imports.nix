rec {
  nixos = nix-darwin;

  nix-darwin =
    { inputs, ... }:
    {
      homeConfig.imports = [ inputs.self.homeModules.vscode ];
    };
}
