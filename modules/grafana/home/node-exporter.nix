{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.self.grafana.enabled {
  self.grafana.scrapeConfigs.node-exporter.static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];

  systemd.user.services.node_exporter = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = lib.escapeShellArgs [
        "${pkgs.prometheus-node-exporter}/bin/node_exporter"
        "--web.listen-address=127.0.0.1:9100"
        "--collector.disable-defaults"
        "--web.disable-exporter-metrics"
        "--collector.cpu"
        "--no-collector.cpu.guest"
        "--collector.meminfo"
        "--collector.diskstats"
        "--collector.netdev"
        "--collector.netdev.device-exclude=^(br-|veth)"
        "--collector.zfs"
        "--collector.stat"
      ];
    };
  };
}
