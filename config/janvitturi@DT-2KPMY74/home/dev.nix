{ inputs, pkgs, ... }:
let
  pkgs' = rec {
    gcc = pkgs.gcc9;
    gccCross = pkgs.runCommand "" { } ''
      mkdir -p $out/bin
      ln -s ${gcc}/bin/gcc $out/bin/${pkgs.hostPlatform.system}-gnu-gcc
    '';
  };
in
{
  imports = with inputs.self.homeModules; [
    git
    go
    python
  ];

  home.packages = with pkgs; [
    pkgs'.gcc
    pkgs'.gccCross

    glibc
    gnumake
    jetbrains.clion
    jetbrains.idea-community
  ];
}
