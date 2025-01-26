{ pkgs, ... }:
let
  cask = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Homebrew/homebrew-cask/66c65cb85501a0801be2302ce4bfd5430c355315/Casks/c/colorpicker-skalacolor.rb";
    hash = "sha256-UtN8eg5CX2D7e3eiNmsdNOuRqrSJSmdh9qchE5CChrM=";
  };
in
{
  self.homebrew = {
    taps."homebrew/colorpicker-skalacolor" = pkgs.runCommand "" { } ''
      mkdir -p $out/Casks
      ln -s ${cask} $out/Casks/colorpicker-skalacolor.rb
    '';

    casks = [ "homebrew/colorpicker-skalacolor/colorpicker-skalacolor" ];
  };
}
