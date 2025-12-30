{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/nixos/any-base/nixpkgs.nix") ];

  home.shellAliases = {
    nixpkgs = ''_nixpkgs() { history -a; NIXPKGS_ALLOW_UNFREE=1 nix shell --impure $(printf ' nixpkgs#%s' "$@"); }; _nixpkgs'';
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
