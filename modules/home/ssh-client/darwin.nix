{ pkgs, ... }@args:
let
  type = "ed25519";
  key = "${args.config.home.homeDirectory}/.ssh/id_${type}";
in
args.lib.mkIf pkgs.hostPlatform.isDarwin {
  self.ssh-client.config = ''
    Host *
      IgnoreUnknown UseKeychain
      UseKeychain yes
      AddKeysToAgent yes
  '';

  self.scripts.write.ssh-client-id = {
    path = [ "darwin" ];
    text = ''
      if ! [ -e ${key} ]; then
        export SSH_ASKPASS=$(mktemp)
        export SSH_ASKPASS_REQUIRE=force
        (
          printf 'printf '
          set +o pipefail
          LC_ALL=C tr -dc 0-9A-Za-z < /dev/random | head -c64
        ) > "$SSH_ASKPASS"
        chmod u+x "$SSH_ASKPASS"

        ssh-keygen -t ${type} -f ${key}
        ssh-add --apple-use-keychain ${key}

        rm "$SSH_ASKPASS"
      fi
    '';
  };
}
