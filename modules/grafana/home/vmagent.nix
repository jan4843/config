{
  config,
  lib,
  pkgs,
  ...
}:
let
  promscrape = {
    raw = (pkgs.formats.json { }).generate "prometheus.yaml" {
      scrape_configs = lib.mapAttrsToList (
        name: value: { job_name = name; } // value
      ) config.self.grafana.scrapeConfigs;
    };
    validated = pkgs.runCommand "prometheus.yaml" { } ''
      ${pkgs.vmagent}/bin/vmagent -dryRun -promscrape.config=${promscrape.raw}
      cp ${promscrape.raw} $out
    '';
  };
in
{
  options.self.grafana = {
    enabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    remoteWriteURLFile = lib.mkOption {
      type = lib.types.path;
    };

    scrapeConfigs = lib.mkOption {
      type = lib.types.attrsOf (pkgs.formats.json { }).type;
      default = { };
    };
  };

  config = lib.mkIf config.self.grafana.enabled {
    systemd.user.services.vmagent = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Environment = [
          "httpListenAddr="
          "promscrape_config=${promscrape.validated}"
          "remoteWrite_forcePromProto=true"
          "remoteWrite_label=instance=%l"
          "remoteWrite_tmpDataPath=/tmp/vmagent-data"
        ];
        RuntimeDirectory = "%N";
        ExecStartPre = pkgs.writeShellScript "vmagent-env" ''
          umask u=r,go=
          printf 'remoteWrite_url=%q\n' "$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg config.self.grafana.remoteWriteURLFile})" > "$RUNTIME_DIRECTORY/env"
        '';
        ExecStart = pkgs.writeShellScript "vmagent-start" ''
          set -a
          . "$RUNTIME_DIRECTORY/env"
          exec ${lib.getExe pkgs.vmagent} -envflag.enable
        '';
      };
    };
  };
}
