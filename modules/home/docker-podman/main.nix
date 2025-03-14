{ pkgs, ... }@args:
let
  pkgs'.docker = pkgs.writeScriptBin "docker" ''
    exec podman "$@"
  '';
in
{
  imports = [ args.inputs.self.homeModules.docker ];

  home.packages = with pkgs; [
    pkgs'.docker

    podman
    podman-compose
  ];

  systemd.user.services.podman = {
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      ExecStart = args.lib.escapeShellArgs [
        "${pkgs.podman}/bin/podman"
        "system"
        "service"
        "--time=0"
        "unix://%t/docker.sock"
      ];
    };
  };

  home.file = {
    ".config/containers/policy.json".source = "${pkgs.skopeo.policy}/default-policy.json";

    ".config/containers/registries.conf".text = ''
      unqualified-search-registries = ["docker.io"]
    '';
  };

  self.backup.paths = [
    "${args.config.home.homeDirectory}/.config/containers/registries.conf.d"
  ];

  programs.bash.initExtra = ''
    __load_completion podman
    complete -F __start_podman docker
  '';
}
