{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pkgs'.lsfg-vk = inputs.lsfg-vk.packages.${pkgs.stdenv.hostPlatform.system}.lsfg-vk;
  layer = "share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json";

  cfg = rec {
    path = "/tmp/lsfg-vk.toml";
    x1 = mk 1;
    x2 = mk 2;
    x3 = mk 3;
    x4 = mk 4;
    mk =
      x:
      builtins.toFile "lsfg-${toString x}x" ''
        # ${toString x}x
        version = 1
        [[game]]
        exe = "default"
        multiplier = ${toString x}
        performance_mode = true
      '';
  };
in
{
  home.file.".local/${layer}".source = "${pkgs'.lsfg-vk}/${layer}";

  systemd.user.sessionVariables = {
    LSFG_PROCESS = "default";
    LSFG_CONFIG = "/tmp/lsfg-vk.toml";
  };

  systemd.user.services.lsfg-vk-init = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = lib.escapeShellArgs [
        "/bin/sh"
        "-c"
        "cat ${cfg.x1} > ${cfg.path}"
      ];
    };
  };

  self.quick-access-scripts = {
    "15-lossless" = ''
      case ''${1:-} in
        "Lossless Scaling (1x)") cat ${cfg.x2} > ${cfg.path} ;;
        "Lossless Scaling (2x)") cat ${cfg.x3} > ${cfg.path} ;;
        "Lossless Scaling (3x)") cat ${cfg.x4} > ${cfg.path} ;;
        "Lossless Scaling (4x)") cat ${cfg.x1} > ${cfg.path} ;;
        *) echo "Lossless Scaling ($(grep -o '[0-9]x' ${cfg.path} || echo 1x))" ;;
      esac
    '';
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/Lossless Scaling/Lossless.dll"
  ];
}
