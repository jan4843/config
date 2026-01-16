{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  news.display = "silent";
}
