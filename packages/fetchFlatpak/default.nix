# nix shell nixpkgs#flatpak
# export FLATPAK_USER_DIR=$(mktemp -d) && flatpak() { command flatpak --user "$@"; } && flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak --verbose --noninteractive install flathub org.mozilla.firefox 2>&1 | grep resolved
# flatpak remote-info --log flathub org.mozilla.firefox
{ pkgs, lib, ... }:
{
  repo ? "https://dl.flathub.org/repo/flathub.flatpakrepo",
  refs,
  hash,
  overrides ? { },
}:
let
  app = lib.pipe refs [
    (builtins.filter (ref: lib.hasPrefix "app/" ref))
    builtins.head
    (builtins.split "/")
    (x: builtins.elemAt x 2)
  ];

  runtime =
    pkgs.runCommand app
      {
        NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        outputHash = hash;
        outputHashAlgo = if hash == "" then "sha256" else null;
        outputHashMode = "recursive";
      }
      ''
        mkdir -p ./root/sys/{block,bus,class,dev,devices}
        flatpak() (
          set -x
          ${pkgs.bubblewrap}/bin/bwrap \
            --bind ./root / \
            --bind $PWD $PWD \
            --bind /etc /etc \
            --bind /nix /nix \
            --bind /proc /proc \
            --bind /tmp /tmp \
            --dev-bind /dev /dev \
            --setenv FLATPAK_USER_DIR $PWD/user \
            ${pkgs.flatpak}/bin/flatpak --verbose --user "$@"
        )

        flatpak remote-add repo ${lib.escapeShellArg repo}
        for ref_commit in ${lib.escapeShellArgs refs}; do
          ref=''${ref_commit%@*}
          commit=''${ref_commit#*@}
          flatpak install --noninteractive --no-related --no-deps --subpath=TMPNONEXISTENT "$ref"
          flatpak update  --noninteractive --no-related --no-deps --subpath= --commit="$commit" "$ref"
        done

        mkdir $out
        mv ./user/{app,runtime} $out
      '';

  override = pkgs.writeText "" (
    lib.generators.toINI {
      mkKeyValue = k: v: "${k}=${if lib.isList v then lib.concatStringsSep ";" v else toString}";
    } overrides
  );
in
pkgs.writeScriptBin app ''
  exec ${pkgs.bubblewrap}/bin/bwrap \
    --dev-bind / / \
    --tmpfs ~/.local/share/flatpak \
    --ro-bind ${runtime}/app ~/.local/share/flatpak/app \
    --ro-bind ${runtime}/runtime ~/.local/share/flatpak/runtime \
    --ro-bind ${override} ~/.local/share/flatpak/overrides/${app} \
    ${pkgs.flatpak}/bin/flatpak --user run ${app} "$@"
''
