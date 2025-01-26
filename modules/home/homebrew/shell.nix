{ config, lib, ... }:
lib.mkIf config.self.homebrew.enable {
  home.sessionPath = [
    "${config.self.homebrew.prefix}/bin"
    "${config.self.homebrew.prefix}/sbin"
  ];

  home.sessionVariables = rec {
    HOMEBREW_NO_AUTO_UPDATE = "1";
    HOMEBREW_NO_INSTALL_FROM_API = "1";
    HOMEBREW_PREFIX = config.self.homebrew.prefix;
    HOMEBREW_REPOSITORY = HOMEBREW_PREFIX;
  };

  programs.bash.profileExtra = ''
    . ${config.self.homebrew.prefix}/completions/bash/brew

    for f in ${config.self.homebrew.prefix}/etc/bash_completion.d/*; do
      if [ -f "$f" ]; then
        source "$f"
      fi
    done; unset f
  '';
}
