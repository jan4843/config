{ casks, pkgs, ... }:
let
  tap = "homebrew/colorpicker-skalacolor";
  formula = "colorpicker-skalacolor";
  cask = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Homebrew/homebrew-cask/66c65cb85501a0801be2302ce4bfd5430c355315/Casks/c/colorpicker-skalacolor.rb";
    hash = "sha256-UtN8eg5CX2D7e3eiNmsdNOuRqrSJSmdh9qchE5CChrM=";
  };
in
{
  ois.homebrew = {
    taps.${tap} = pkgs.runCommand "" { } ''
      install -D ${cask} $out/Casks/${formula}.rb
    '';
    casks = [ casks."${tap}/${formula}" ];
  };
}
