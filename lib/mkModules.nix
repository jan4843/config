{ self, ... }:
dir:
let
  modules = self.lib.mapDir (path: path) dir;
in
{
  default = {
    key = "default";
    imports = builtins.attrValues modules;
  };
}
// modules
