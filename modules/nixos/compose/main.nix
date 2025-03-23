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
  environment.etc = args.lib.mapAttrs' (project: compose: {
    name = "compose/${project}/compose.yaml";
    value.source = "${mkCompose project compose}/compose.yaml";
  }) args.config.self.compose.projects;

  systemd.services = args.lib.mapAttrs' (project: compose: {
    name = "compose@${project}";
    value = {
      requires = [ "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ args.config.environment.etc."compose/${project}/compose.yaml".source ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/compose/${project}";

        ExecStart =
          [
            "-${pkgs.docker}/bin/docker compose down --remove-orphans --rmi"
            "${pkgs.docker}/bin/docker compose create --build --quiet-pull"
          ]
          ++ (args.lib.optional ((upServices compose) != [ ])
            "${pkgs.docker}/bin/docker compose up --detach --wait ${args.lib.escapeShellArgs (upServices compose)}"
          );

        ExecStop = [ "${pkgs.docker}/bin/docker compose down" ];
      };
    };
  }) args.config.self.compose.projects;
}
