{ pkgs, ... }@args:
let
  hookScript =
    name: hooks:
    pkgs.writeShellApplication {
      inherit name;
      text = args.lib.concatLines (builtins.attrValues hooks);
    };

  hooksEnv = pkgs.buildEnv {
    name = "hooks";
    paths = args.lib.attrsets.mapAttrsToList hookScript args.config.self.git.hooks;
    pathsToLink = [ "/bin" ];
  };
in
{
  home.packages = [ pkgs.git ];

  home.file = {
    ".config/git/config".text = args.lib.generators.toGitINI args.config.self.git.config;
    ".config/git/ignore".text = args.lib.concatLines args.config.self.git.ignore;
    ".config/git/hooks".source = "${hooksEnv}/bin";
  };

  programs.bash.initExtra = ''
    . ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
  '';
}
