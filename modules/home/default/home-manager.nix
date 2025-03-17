{ pkgs, ... }@args:
let
  patch = {
    "-" = ''username != "root"'';
    "+" = ''username != ""'';
  };
  original = rec {
    path = "${args.inputs.home-manager}/modules/systemd.nix";
    content = builtins.readFile path;
  };
  patched = rec {
    path = builtins.toFile "systemd.nix" content;
    content = builtins.replaceStrings [ patch."-" ] [ patch."+" ] original.content;
  };
in
{
  disabledModules = [ original.path ];
  imports = [ patched.path ];

  systemd.user.startServices = true;
  news.display = "silent";

  targets.genericLinux.enable = pkgs.hostPlatform.isLinux;
}
