{ pkgs, ... }@args:
let
  mkScript = target: name: cfg: ''
    set -e
    (
      printf '\e[4m%s\e[0m\n' self.scripts.${target}.${args.lib.escapeShellArg name} >&2

      PATH=
      ${args.lib.optionalString (builtins.elem "darwin" cfg.path) ''
        eval "$(/usr/libexec/path_helper)"
      ''}
      PATH=${args.lib.makeBinPath (args.lib.remove "darwin" cfg.path)}:''${PATH:+$PATH}

      cd

      ${pkgs.coreutils}/bin/env -i \
      USER=${args.lib.escapeShellArg args.config.home.username} \
      HOME=${args.lib.escapeShellArg args.config.home.homeDirectory} \
      PATH="$PATH" \
      ${pkgs.bash}/bin/bash \
      ${pkgs.writeScript name cfg.text} || {
        printf '\e[31m%s\e[0m\n' "exited with code $?" >&2
        exit 1
      }
    )
  '';

  mkActivation =
    target:
    toString (
      pkgs.writeScript target (
        toString (
          args.lib.attrsets.mapAttrsToList (
            name: cfg: mkScript target name cfg
          ) args.config.self.scripts.${target}
        )
      )
    );
in
{
  home.activation = {
    customChecks = args.lib.hm.dag.entryBefore [ "checkFilesChanged" ] (mkActivation "check");

    customInstalls = args.lib.hm.dag.entryBetween [ "linkGeneration" ] [ "installPackages" ] (
      mkActivation "install"
    );

    customWrites = args.lib.hm.dag.entryAfter [ "linkGeneration" ] (mkActivation "write");
  };
}
