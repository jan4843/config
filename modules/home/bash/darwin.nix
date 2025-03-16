{ pkgs, ... }@args:
let
  shellPath = "/run/current-system/sw${pkgs.bashInteractive.shellPath}";
in
args.lib.mkIf pkgs.hostPlatform.isDarwin {
  assertions = [
    {
      assertion = builtins.elem shellPath args.osConfig.environment.shells;
      message = "osConfig.environment.shells does not contain ${args.lib.strings.escapeNixString shellPath}";
    }
  ];

  self.scripts.write.shell = {
    path = [ "darwin" ];
    text = ''
      if [ "$(dscl . -read ${args.config.home.homeDirectory} UserShell)" != "UserShell: ${shellPath}" ]; then
        sudo dscl . -create ${args.config.home.homeDirectory} UserShell ${shellPath}
      fi
    '';
  };

  programs.vscode.userSettings = {
    "terminal.integrated.defaultProfile.osx" = "bash";
    "terminal.integrated.profiles.osx".bash = {
      "source" = shellPath;
      "args" = [ "-himBHs" ];
    };
  };
}
