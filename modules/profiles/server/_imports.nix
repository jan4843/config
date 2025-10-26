{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profiles.shared.extra
      ];
      homeConfig.imports = [ inputs.self.homeModules.profiles.server ];
    };
}
