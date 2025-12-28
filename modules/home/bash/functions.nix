{ config, lib, ... }:
{
  self.bash.profile = lib.mkBefore (
    lib.concatLines (
      lib.attrsets.mapAttrsToList (name: body: ''
        function ${name} {
        ${body}
        }
      '') config.self.bash.functions
    )
  );
}
