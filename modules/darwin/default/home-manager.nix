{
  config,
  lib,
  extendModules,
  ...
}:
let
  original = extendModules { modules = [ { _overtakeHomeManagerCheckScripts = false; } ]; };
  user = builtins.head (builtins.attrNames original.config.home-manager.users);
in
{
  options._overtakeHomeManagerCheckScripts = lib.mkOption { default = true; };

  config = lib.mkIf config._overtakeHomeManagerCheckScripts {
    home-manager.users.${user}.home.activation.customChecks = lib.mkForce "";

    system.activationScripts.preUserActivation.text = lib.mkBefore ''
      printf '%s\n' >&2 \
        "running home-manager checks..."
      ${original.config.home-manager.users.${user}.home.activation.customChecks.data}
    '';
  };
}
