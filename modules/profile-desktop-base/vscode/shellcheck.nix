{
  home-manager =
    {
      lib,
      pkgs,
      vscode-marketplace,
      ...
    }:
    {
      programs.vscode.profiles.default = {
        extensions = with vscode-marketplace; [ timonwong.shellcheck ];

        userSettings = {
          "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;
          "shellcheck.disableVersionCheck" = true;
        };
      };
    };
}
