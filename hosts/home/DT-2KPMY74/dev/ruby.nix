{ lib, pkgs, ... }:
let
  libs = with pkgs; [
    libffi
    libxcrypt
    libyaml.dev
    openssl
    zlib
    zlib
  ];

  cflags = flags (p: "-I${p}/include") libs;
  ldflags = flags (p: "-L${p}/lib") libs;
  flags =
    fn: list:
    lib.pipe list [
      (map fn)
      (lib.concatStringsSep " ")
      lib.escapeShellArg
    ];
in
{
  home.packages = with pkgs; [
    jetbrains.ruby-mine
    jruby
    ruby
  ];

  home.sessionVariables = {
    JAVA_TOOL_OPTIONS = "-Djava.library.path=${lib.makeLibraryPath [ pkgs.stdenv.cc.libc ]}";
    BUNDLE_BUILD__ALL = "--with-cflags=${cflags} --with-ldflags=${ldflags}";
  };
}
