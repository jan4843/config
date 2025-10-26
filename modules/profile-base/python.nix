{
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [ (pkgs.python3.withPackages (ps: [ ps.pip ])) ];

      self.git.ignore = [
        ".venv/"
      ];

      self.bash = {
        promptInfo.pythonVenv = ''
          test -z "$VIRTUAL_ENV" || echo venv
        '';

        functions.venv = ''
          test -d .venv || python -m venv .venv &&
          VIRTUAL_ENV_DISABLE_PROMPT=1 . .venv/bin/activate
        '';
      };

      home.shellAliases = {
        py = "python";
        pipr = "pip install -r requirements.txt";
      };
    };
}
