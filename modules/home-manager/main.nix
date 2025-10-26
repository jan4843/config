rec {
  nixos = nix-darwin;

  nix-darwin =
    { inputs, ... }:
    {
      home-manager = {
        extraSpecialArgs.inputs = inputs;
        useGlobalPkgs = true;
      };
    };

  home-manager = {
    news.display = "silent";
  };
}
