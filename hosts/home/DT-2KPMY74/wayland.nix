let
  vars = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
in
{
  home.sessionVariables = vars;
  systemd.user.sessionVariables = vars;

  self.vscode.settings."window.titleBarStyle" = "custom";
}
