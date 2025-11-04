{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.self.nixosModules.autoupgrade ];

      self.autoupgrade.flakeref = "github:jan4843/config";
    };
}
