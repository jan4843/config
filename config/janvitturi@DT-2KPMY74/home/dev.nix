{ inputs, pkgs, ... }:
let
  pkgs'.gccCross = pkgs.writeScriptBin "${pkgs.hostPlatform.system}-gnu-gcc" ''
    exec gcc "$@"
  '';
in
{
  imports = with inputs.self.homeModules; [
    git
    go
    python
  ];

  home.packages = with pkgs; [
    pkgs'.gccCross

    gcc9
    glibc
    gnumake
    jetbrains.clion
    jetbrains.idea-community
  ];
}
