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

    mk = enabled: ''
      # enabled=${toString enabled}
      version = 1
      [[game]]
      exe = "default"
      multiplier = ${if enabled then "2" else "1"}
      performance_mode = true
    '';
    enabled = builtins.toFile "lsfg-enabled" (mk true);
    disabled = builtins.toFile "lsfg-disabled" (mk false);
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
      Type = "oneshot";
      ExecStart = lib.escapeShellArgs [
        "/bin/sh"
        "-c"
        "cat ${cfg.disabled} > ${cfg.path}"
      ];
    };
  };

  self.quick-access-scripts = {
    "15-lossless" = ''
      case ''${1:-} in
        "Enable Lossless Scaling")
          cat ${cfg.enabled} > ${cfg.path} ;;
        "Disable Lossless Scaling")
          cat ${cfg.disabled} > ${cfg.path} ;;
        *)
          grep -q enabled=1 ${cfg.path} &&
          echo "Disable Lossless Scaling" ||
          echo "Enable Lossless Scaling" ;;
      esac
    '';
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/Lossless Scaling/Lossless.dll"
  ];
}
