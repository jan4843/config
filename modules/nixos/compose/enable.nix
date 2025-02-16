{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkCompose = pkgs.callPackage ./mkCompose { };

  upServices =
    compose:
    lib.pipe compose.services [
      (lib.filterAttrs (_: service: service.restart or "no" != "no"))
      builtins.attrNames
    ];
in
{
  systemd.services = lib.mapAttrs' (project: compose: {
    name = "compose@${project}";
    value = {
      requires = [ "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      environment.COMPOSE_FILE = mkCompose project compose;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          [
            "${pkgs.docker}/bin/docker compose create --build --quiet-pull --remove-orphans"
          ]
          ++ (lib.optional ((upServices compose) != [ ])
            "${pkgs.docker}/bin/docker compose up --detach --wait ${lib.escapeShellArgs (upServices compose)}"
          );

        ExecStop = [ "${pkgs.docker}/bin/docker compose down" ];
      };
    };
  }) config.self.compose.projects;
}
