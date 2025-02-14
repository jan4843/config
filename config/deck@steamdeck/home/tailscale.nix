{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.tailscale-linux ];

  self.tailscale = {
    tags = [ "edge" ];
    upFlags = [ "--ssh" ];
  };
}
