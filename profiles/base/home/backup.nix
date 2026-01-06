{
  inputs,
  lib,
  osConfig,
  ...
}:
{
  imports = [ inputs.self.homeModules.backup ];

  self.backup = {
    passwordFile = lib.mkDefault "/nix/secrets/${osConfig.networking.hostName}/backup.password";
  };
}
