{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.self.nixosModules.vscode ];
    };

  nix-darwin =
    { inputs, ... }:
    {
      imports = [ inputs.self.darwinModules.vscode ];
    };

  home-manager =
    { inputs, ... }:
    {
      imports = [ inputs.self.homeModules.vscode ];
    };
}
