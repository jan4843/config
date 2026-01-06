{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  self.backup = {
    repositoryPrefixFile = lib.mkDefault "/nix/secrets/personal/backup.repository-prefix";
  };
}
