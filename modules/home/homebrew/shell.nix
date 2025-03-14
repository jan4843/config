args: {
  home.sessionPath = [
    "${args.config.self.homebrew.prefix}/bin"
    "${args.config.self.homebrew.prefix}/sbin"
  ];

  home.sessionVariables = rec {
    HOMEBREW_NO_AUTO_UPDATE = "1";
    HOMEBREW_NO_INSTALL_FROM_API = "1";
    HOMEBREW_PREFIX = args.config.self.homebrew.prefix;
    HOMEBREW_REPOSITORY = HOMEBREW_PREFIX;
  };

  programs.bash.profileExtra = ''
    . ${args.config.self.homebrew.prefix}/completions/bash/brew

    for f in ${args.config.self.homebrew.prefix}/etc/bash_completion.d/*; do
      if [ -f "$f" ]; then
        source "$f"
      fi
    done; unset f
  '';
}
