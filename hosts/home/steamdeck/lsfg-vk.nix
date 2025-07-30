{ pkgs, ... }@args:
let
  pkgs'.lsfg-vk = args.inputs.lsfg-vk.packages.${pkgs.system}.lsfg-vk;
  layer = "share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json";
  vars = {
    # https://github.com/PancakeTAS/lsfg-vk/wiki/Configuring-lsfg%E2%80%90vk
    LSFG_LEGACY = "1";
    LSFG_DLL_PATH = "${args.config.home.homeDirectory}/.local/share/lsfg-vk/Lossless.dll";
    LSFG_MULTIPLIER = "1";
    LSFG_PERFORMANCE_MODE = "1";
  };
in
{
  home.file.".local/${layer}".source = "${pkgs'.lsfg-vk}/${layer}";

  home.sessionVariables = vars;
  systemd.user.sessionVariables = vars;
}
