{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  includeIf = cond: ''includeIf "${lib.escape [ "\"" ] cond}"'';
  mkInclude = cfg: { path = pkgs.writeText "" (lib.generators.toGitINI cfg); };
in
{
  imports = [ inputs.self.homeModules.git ];

  self.git.config = {
    alias = {
      l = ''!git --no-pager log --max-count=50 --reverse --oneline'';
      s = ''status --short'';

      amend = ''commit --amend --allow-empty-message --no-edit'';
      autorebase = ''!git -c sequence.editor=: rebase --interactive --autosquash'';
      fixup = ''git commit --fixup="$(git log -1 --pretty=format:%H --grep=^fixup! --invert-grep)"'';
      save = ''!git add --all && git commit --allow-empty-message --no-edit'';

      regex = ''log --source --all --reverse --patch -G'';
      string = ''log --source --all --reverse --patch -S'';
    };

    pull = {
      ff = "only";
      rebase = true;
    };

    push = {
      autosetupremote = true;
    };

    url = {
      "git@github.com:" = {
        pushInsteadOf = "https://github.com";
      };
    };

    user = {
      name = "Jan Vitturi";
      useConfigOnly = true;
    };

    ${includeIf "hasconfig:remote.*.url:**github.com**"} = mkInclude {
      user = {
        email = "1881325+jan4843@users.noreply.github.com";
      };
    };
  };

  self.git.hooks.pre-commit.nocommit = pkgs.writeScript "" ''
    git diff --cached -S NOCOMMIT --exit-code
  '';

  self.bash.promptInfo.git = ''
    GIT_PS1_SHOWDIRTYSTATE=1 \
    GIT_PS1_SHOWUNTRACKEDFILES=1 \
    GIT_PS1_STATESEPARATOR= \
    __git_ps1 %s
  '';
}
