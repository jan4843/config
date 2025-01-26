{ lib, pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ./heredocker { })
    (pkgs.callPackage ./shelldocker { })
  ];

  self.bash = {
    functions.upd = ''
      (
        set -e
        docker compose config --quiet
        docker compose pull "$@"
        docker compose build "$@" --pull
        docker compose down --remove-orphans
        local start
        start=$(date -Iseconds)
        docker compose up "$@" --detach
        docker compose logs --follow --since="$start"
      )
    '';

    aliases.compose = "docker compose";

    profile = "complete -F _docker_compose compose";
  };

  self.vscode = {
    extensions = [
      "exiasr.hadolint"
      "ms-azuretools.vscode-docker"
    ];

    settings = {
      "hadolint.hadolintPath" = lib.getExe pkgs.hadolint;
    };
  };
}
