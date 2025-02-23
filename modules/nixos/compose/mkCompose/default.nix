{ pkgs, ... }:
project: compose:
pkgs.runCommand "${project}.yaml"
  {
    COMPOSE_PROJECT_NAME = project;
    COMPOSE_FILE = pkgs.writers.writeJSON "" compose;

    nativeBuildInputs = with pkgs; [
      docker
      jq
      skopeo
    ];
  }
  ''
    test "$(docker compose config --variables | wc -l)" = 1

    mkdir ensure-no-relative-path; cd $_
    docker compose config --output=$out
    ! grep ensure-no-relative-path $out

    for image in $(docker compose config --images); do
      [[ $image = /nix/store/* ]] || continue
      digest=$(skopeo inspect --tmpdir=. --raw "docker-archive:$image" | jq -r .config.digest)
      sed -i "s,$image,$digest,g" $out
    done
  ''
