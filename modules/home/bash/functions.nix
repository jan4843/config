{ config, lib, ... }:
{
  self.bash.profile = lib.concatLines (
    lib.attrsets.mapAttrsToList (name: body: ''
      ${name}() {
      ${body}
      }
    '') config.self.bash.functions
  );
}
