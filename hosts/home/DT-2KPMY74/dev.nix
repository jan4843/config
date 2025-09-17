{ pkgs, ... }@args:
let
  pkgs' = {
    cmake-mold = pkgs.writeShellScriptBin "cmake-mold" ''
      exec mold -run cmake "$@"
    '';

    gcc-ccache = pkgs.writeShellScriptBin "gcc-ccache" ''
      exec ccache gcc "$@"
    '';

    gxx-ccache = pkgs.writeShellScriptBin "g++-ccache" ''
      exec ccache g++ "$@"
    '';

    gcc-cross = pkgs.writeShellScriptBin "${pkgs.hostPlatform.system}-gnu-gcc" ''
      exec gcc "$@"
    '';

    gxx-cross = pkgs.writeShellScriptBin "${pkgs.hostPlatform.system}-gnu-g++" ''
      exec g++ "$@"
    '';
  };

  flags =
    fn: list:
    args.lib.pipe list [
      (map fn)
      (args.lib.concatStringsSep " ")
      args.lib.strings.escapeShellArg
    ];
in
{
  imports = with args.inputs.self.homeModules; [
    git
    go
    python
  ];

  home.packages =
    [ ]
    ++ (with pkgs'; [
      cmake-mold
      gcc-ccache
      gxx-ccache
      gcc-cross
      gxx-cross
    ])
    ++ (with pkgs; [
      ccache
      clang-tools
      cmake
      gcc9
      glibc
      gnumake
      jetbrains.clion
      jetbrains.goland
      jetbrains.idea-community
      jetbrains.ruby-mine
      mold
      ruby_3_4
    ]);

  home.sessionVariables = {
    JAVA_TOOL_OPTIONS = "-Djava.library.path=${
      args.lib.makeLibraryPath [
        pkgs.stdenv.cc.libc
      ]
    }";

    BUNDLE_BUILD__ALL = "--with-cflags=${
      flags (p: "-I${p}/include") [
        pkgs.libyaml.dev
      ]
    } --with-ldflags=${
      flags (p: "-L${p}/lib") [
        pkgs.openssl
        pkgs.zlib
        pkgs.libffi
        pkgs.zlib
        pkgs.libxcrypt
      ]
    }";
  };
}
