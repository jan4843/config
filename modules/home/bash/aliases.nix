{ config, lib, ... }:
{
  self.bash.profile = lib.concatLines (
    lib.attrsets.mapAttrsToList (name: body: ''
      alias -- ${lib.escapeShellArg name}=${lib.escapeShellArg body}
    '') config.self.bash.aliases
  );
}
