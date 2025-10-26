{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profile-extra
      ];
      homeConfig.imports = [ inputs.self.homeModules.profile-server ];
    };
}
