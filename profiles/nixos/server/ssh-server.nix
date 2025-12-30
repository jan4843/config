{ inputs, ... }:
{
  imports = [ (inputs.self + "/modules/nixos/ssh-server") ];

  self.ssh-server.importID = "gh:jan4843";
}
