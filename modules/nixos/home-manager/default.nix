{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    inputs.home-manager.nixosModules.home-manager
  ];

  homeConfig.imports = [ (inputs.self + "/modules/home/home-manager") ];

  home-manager = {
    extraSpecialArgs.inputs = inputs;
    useGlobalPkgs = true;
  };

  users.users.root.linger = true;

  homeConfig.home.stateVersion = config.system.stateVersion;
}
