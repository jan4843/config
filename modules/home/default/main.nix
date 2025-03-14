{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    scripts
  ];
}
