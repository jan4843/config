{
  home-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      type = "ed25519";
      key = lib.escapeShellArg "${config.home.homeDirectory}/.ssh/id_${type}";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      self.ssh-client.config = ''
        Host *
          IgnoreUnknown UseKeychain
          UseKeychain yes
          AddKeysToAgent yes
      '';

      home.activation.sshKeygen = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ! [ -e ${key} ]; then
          export SSH_ASKPASS=$(mktemp)
          export SSH_ASKPASS_REQUIRE=force
          (
            printf 'printf '
            set +o pipefail
            LC_ALL=C tr -dc 0-9A-Za-z < /dev/random | head -c64
          ) > "$SSH_ASKPASS"
          chmod u+x "$SSH_ASKPASS"

          eval "$(/usr/bin/ssh-agent)"
          /usr/bin/ssh-keygen -t ${type} -f ${key}
          /usr/bin/ssh-add --apple-use-keychain ${key}

          rm "$SSH_ASKPASS"
        fi
      '';
    };
}
