{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    profile-any-base
    vscode
  ];
}
