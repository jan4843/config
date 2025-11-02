{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = with pkgs; [
    coreutils
    curl
    gawk
    gnugrep
    gnused
  ];
  text = ''
    { grep -Eo 'github:.+latest=true' flake.nix || :; } |
    while read -r old; do
      user=''${old#"github:"}; user=''${user%%"/"*}
      repo=''${old#"github:$user/"}; repo=''${repo%%"/"*}
      query=''${old#*"?"}
      version=$(
        curl -sI "https://github.com/$user/$repo/releases/latest" |
        awk -F/ '/^[Ll]ocation:/{print $NF}' |
        tr -d '\r'
      )
      new="github:$user/$repo/$version?$query"
      sed -i.bak "s|$old|$new|g" flake.nix
      rm flake.nix.bak
    done
    set -x
    nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update
  '';
}
