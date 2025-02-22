{ inputs, pkgs, ... }:
let
  pkgs'.docker = pkgs.writeScriptBin "docker" ''
    exec podman "$@"
  '';
in
{
  imports = [ inputs.self.homeModules.docker ];

  programs.bash.initExtra = ''
    __load_completion podman
    complete -F __start_podman docker
  '';

  home.packages = with pkgs; [
    pkgs'.docker

    podman
    podman-compose
  ];
}
