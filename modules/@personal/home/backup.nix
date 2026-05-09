{ lib, ... }:
{
  self.backup = {
    repositoryPrefixFile = lib.mkDefault "/nix/secrets/personal/backup.repository-prefix";
  };
}
