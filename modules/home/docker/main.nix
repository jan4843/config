{ pkgs, vscode-marketplace, ... }:
{
  home.packages = [
    (pkgs.callPackage ./.pkgs/heredocker { })
    (pkgs.callPackage ./.pkgs/shelldocker { })
  ];

  self.bash = {
    functions.upd = ''
      (
        set -e
        docker compose config >/dev/null
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

  programs.vscode.profiles.default = {
    extensions = with vscode-marketplace; [
      exiasr.hadolint
      ms-azuretools.vscode-containers
    ];

    userSettings = {
      "hadolint.hadolintPath" = "${pkgs.hadolint}/bin/hadolint";
    };
  };
}
