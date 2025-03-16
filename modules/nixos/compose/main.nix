{ pkgs, ... }@args:
let
  mkCompose = pkgs.callPackage ./_lib/mkCompose.nix { };

  upServices =
    compose:
    args.lib.pipe compose.services [
      (args.lib.filterAttrs (_: service: service.restart or "no" != "no"))
      builtins.attrNames
    ];
in
{
  systemd.services = args.lib.mapAttrs' (project: compose: {
    name = "compose@${project}";
    value = {
      requires = [ "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      environment.COMPOSE_FILE = "${mkCompose project compose}/compose.yaml";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          [
            "${pkgs.docker}/bin/docker compose create --build --quiet-pull --remove-orphans"
          ]
          ++ (args.lib.optional ((upServices compose) != [ ])
            "${pkgs.docker}/bin/docker compose up --detach --wait ${args.lib.escapeShellArgs (upServices compose)}"
          );

        ExecStop = [ "${pkgs.docker}/bin/docker compose down" ];
      };
    };
  }) args.config.self.compose.projects;
}
