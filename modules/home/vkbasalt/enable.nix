{ pkgs, ... }:
{
  home.file.".local/share/vulkan/implicit_layer.d/vkBasalt.json".source =
    "${pkgs.vkbasalt}/share/vulkan/implicit_layer.d/vkBasalt.json";

  home.file.".config/vkBasalt/vkBasalt.conf".text = ''
    effects = smaa:fxaa:cas
  '';
}
