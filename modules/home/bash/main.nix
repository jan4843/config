args: {
  programs.bash = {
    enable = true;
    initExtra = args.config.self.bash.profile;
  };
}
