{ inputs, lib, ... }:
{
  imports = [ inputs.self.homeModules.backup ];

  self.backup = {
    repositoryFile = lib.mkDefault "/nix/secrets/backup.repository";
    passwordFile = lib.mkDefault "/nix/secrets/backup.password";
  };
}
