{
  nixos =
    { config, inputs, ... }:
    let
      patch = {
        "-" = ''username != "root"'';
        "+" = ''username != ""'';
      };
      original = rec {
        path = "${inputs.home-manager}/modules/systemd.nix";
        content = builtins.readFile path;
      };
      patched = rec {
        path = builtins.toFile "systemd.nix" content;
        content = builtins.replaceStrings [ patch."-" ] [ patch."+" ] original.content;
      };
    in
    {
      users.users.root.linger = true;

      homeConfig = {
        disabledModules = [ original.path ];
        imports = [ patched.path ];

        home.stateVersion = config.system.stateVersion;
      };
    };
}
