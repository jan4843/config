{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;
}
