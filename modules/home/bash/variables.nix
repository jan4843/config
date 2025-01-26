{ config, lib, ... }:
{
  self.bash.profile = lib.strings.toShellVars config.self.bash.variables;
}
