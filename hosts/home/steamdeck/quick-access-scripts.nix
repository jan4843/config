{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.quick-access-scripts ];

  self.quick-access-scripts = {
    _1-smt = ''
      case ''${1:-} in
        "Enable SMT")
          ${config.self.sudo-passwordless.path} sh -c 'echo on > /sys/devices/system/cpu/smt/control' ;;
        "Disable SMT")
          ${config.self.sudo-passwordless.path} sh -c 'echo off > /sys/devices/system/cpu/smt/control' ;;
        *)
          [ "$(cat /sys/devices/system/cpu/smt/control)" = on ] &&
          echo "Disable SMT" ||
          echo "Enable SMT" ;;
      esac
    '';

    _9-restart-steam = ''
      if [ $# = 0 ]; then
        echo "Restart Steam"
      else
        killall steam
      fi
    '';
  };
}
