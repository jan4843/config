{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop")
    (inputs.self + "/profiles/base+")
  ];

  self.mas = [
    409203825 # Numbers
    1573461917 # SponsorBlock
    6745342698 # uBlock Origin Lite
  ];
}
