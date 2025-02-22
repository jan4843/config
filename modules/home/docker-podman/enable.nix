{
  config,
  inputs,
  pkgs,
  ...
}:
let
  pkgs'.docker = pkgs.writeScriptBin "docker" ''
    exec podman "$@"
  '';
in
{
  imports = [ inputs.self.homeModules.docker ];

  home.packages = with pkgs; [
    pkgs'.docker

    podman
    podman-compose
  ];

  home.file = {
    ".config/containers/policy.json".source = "${pkgs.skopeo.policy}/default-policy.json";

    ".config/containers/registries.conf".text = ''
      unqualified-search-registries = ["docker.io"]
    '';
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.config/containers/registries.conf.d"
  ];

  programs.bash.initExtra = ''
    __load_completion podman
    complete -F __start_podman docker
  '';
}
