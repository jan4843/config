{ inputs, ... }:
{
  home-manager = {
    extraSpecialArgs.inputs = inputs;
    useGlobalPkgs = true;
  };
}
