{ inputs, pkgs, ... }:
let
  pkgs' = {
    cmake-mold = pkgs.writeScriptBin "cmake-mold" ''
      #!/bin/sh
      exec ${pkgs.mold}/bin/mold -run cmake "$@"
    '';

    gcc-ccache = pkgs.writeScriptBin "gcc-ccache" ''
      #!/bin/sh
      exec ${pkgs.ccache}/bin/ccache gcc "$@"
    '';

    gxx-ccache = pkgs.writeScriptBin "g++-ccache" ''
      #!/bin/sh
      exec ${pkgs.ccache}/bin/ccache g++ "$@"
    '';

    gcc-cross = pkgs.writeScriptBin "${pkgs.hostPlatform.system}-gnu-gcc" ''
      #!/bin/sh
      exec gcc "$@"
    '';

    gxx-cross = pkgs.writeScriptBin "${pkgs.hostPlatform.system}-gnu-g++" ''
      #!/bin/sh
      exec g++ "$@"
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
    pkgs'.cmake-mold
    pkgs'.gcc-ccache
    pkgs'.gxx-ccache
    pkgs'.gcc-cross
    pkgs'.gxx-cross

    cmake
    gcc9
    glibc
    gnumake
    jetbrains.clion
    jetbrains.idea-community
  ];
}
