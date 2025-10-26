{
  nixos =
    { inputs, ... }:
    {
      imports = [ inputs.self.nixosModules.ssh-server ];

      self.ssh-server.importID = "gh:jan4843";
    };
}
