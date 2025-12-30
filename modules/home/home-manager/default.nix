{ lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix;

  news.display = "silent";
}
