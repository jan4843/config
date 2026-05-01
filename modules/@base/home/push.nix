{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.push ];

  self.push.keyFile = "/nix/secrets/all/push.key";
}
