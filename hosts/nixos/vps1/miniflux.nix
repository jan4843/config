{ pkgs, ... }@args:
let
  dataDir = "${args.config.self.persistence.path}/miniflux";
in
{
  self.compose.projects.miniflux.services = {
    miniflux = {
      container_name = "miniflux";
      image = "miniflux/miniflux:${pkgs.miniflux.version}";

      ports = [ "127.0.0.1:3205:8080" ];

      environment = {
        DATABASE_URL = "postgres://miniflux:miniflux@postgres/miniflux?sslmode=disable";
        ADMIN_USERNAME = "miniflux";
        ADMIN_PASSWORD = "miniflux";
        CREATE_ADMIN = 1;
        RUN_MIGRATIONS = 1;
        POLLING_PARSING_ERROR_LIMIT = 0;
      };

      restart = "unless-stopped";
      depends_on.postgres.condition = "service_healthy";
    };

    postgres = {
      image = "postgres:17-alpine";
      environment = {
        POSTGRES_USER = "miniflux";
        POSTGRES_PASSWORD = "miniflux";
      };
      volumes = [
        {
          type = "bind";
          source = dataDir;
          target = "/var/lib/postgresql/data";
        }
      ];
      healthcheck = {
        test = "pg_isready";
        start_period = "30s";
        start_interval = "1s";
      };
      restart = "unless-stopped";
    };
  };

  self.freeform.caddy.subsites.miniflux = ''
    reverse_proxy http://127.0.0.1:3205
  '';

  homeConfig.self.backup.paths = [ dataDir ];
}
