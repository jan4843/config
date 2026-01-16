{ inputs, lib, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  self.backup = {
    repositoryPrefixFile = lib.mkDefault "/nix/secrets/personal/backup.repository-prefix";
  };
}
