{ pkgs, ... }:
let
  layer = "share/vulkan/implicit_layer.d/vkBasalt.json";
in
{
  home.file.".local/${layer}".source = "${pkgs.vkbasalt}/${layer}";

  home.file.".config/vkBasalt/vkBasalt.conf".text = ''
    effects = smaa:fxaa:cas
  '';
}
