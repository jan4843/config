{ inputs, ... }:
{
  imports = [ (inputs.self + "/modules/nixos/autoupgrade") ];

  self.autoupgrade.flakeref = "github:jan4843/config";
}
