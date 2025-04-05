{ pkgs, ... }:
project: compose:
pkgs.runCommand "compose.${project}.yaml"
  {
    COMPOSE_PROJECT_NAME = project;
    COMPOSE_FILE = pkgs.lib.pipe compose [
      builtins.toJSON
      (builtins.replaceStrings [ "$" ] [ "$$" ])
      (pkgs.writeText "compose.yaml")
    ];

    nativeBuildInputs = with pkgs; [
      docker
      jq
      skopeo
    ];
  }
  ''
    mkdir ensure-no-relative-path; cd $_
    docker compose config --no-interpolate --output=$out
    ! grep ensure-no-relative-path $out

    for image in $(docker compose config --no-interpolate --images); do
      [[ $image = /nix/store/* ]] || continue
      digest=$(skopeo inspect --tmpdir=. --raw "docker-archive:$image" | jq -r .config.digest)
      sed -i "s,$image,$digest,g" $out
    done
  ''
