{
  config,
  lib,
  pkgs,
  ...
}:
let
  root = "${config.home.homeDirectory}/.local/nix/envs";

  writeCmds = lib.attrsets.mapAttrsToList (_name: cfg: ''
    ${printCommand cfg.vars} > ${cfg.path}
  '') config.self.envs;

  cleanupCmd = ''
    for f in ${lib.escapeShellArg root}/*; do
      test -f "$f" || continue
      case :${lib.escapeShellArg knownFiles}: in
        *:$f:*) ;;
        *) rm -f "$f" ;;
      esac
    done
  '';

  printCommand =
    vars: if (vars != { }) then "printf '%q=%q\n' ${toString (nameContent vars)}" else ":";

  knownFiles = builtins.concatStringsSep ":" (
    builtins.catAttrs "path" (builtins.attrValues config.self.envs)
  );

  nameContent = lib.attrsets.mapAttrsToList (
    env: path: ''${lib.escapeShellArg env} "$(cat ${lib.escapeShellArg path})"''
  );
in
{
  self.scripts.write.envs = {
    path = [ pkgs.coreutils ];
    # TODO
    text = ''
      mkdir -p ${lib.escapeShellArg root}
      umask go=
      ${lib.concatLines writeCmds}
      ${cleanupCmd}
    '';
  };
}
