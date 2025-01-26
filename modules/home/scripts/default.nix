{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkScript = target: name: cfg: ''
    set -e
    (
      printf '\e[4m%s\e[0m\n' self.scripts.${target}.${lib.escapeShellArg name} >&2

      PATH=
      ${lib.optionalString (builtins.elem "darwin" cfg.path) ''
        eval "$(/usr/libexec/path_helper)"
      ''}
      PATH=${lib.makeBinPath (lib.remove "darwin" cfg.path)}:''${PATH:+$PATH}

      cd

      ${pkgs.coreutils}/bin/env -i \
      USER=${lib.escapeShellArg config.home.username} \
      HOME=${lib.escapeShellArg config.home.homeDirectory} \
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
          lib.attrsets.mapAttrsToList (name: cfg: mkScript target name cfg) config.self.scripts.${target}
        )
      )
    );
in
{
  options.self.scripts = rec {
    check = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              path = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.package (lib.types.enum [ "darwin" ]));
                default = [ ];
              };

              text = lib.mkOption { type = lib.types.lines; };
            };
          }
        )
      );
      default = { };
    };

    install = check;

    write = check;
  };

  config = {
    home.activation = {
      customChecks = lib.hm.dag.entryBefore [ "checkFilesChanged" ] (mkActivation "check");

      customInstalls = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "installPackages" ] (
        mkActivation "install"
      );

      customWrites = lib.hm.dag.entryAfter [ "linkGeneration" ] (mkActivation "write");
    };
  };
}
