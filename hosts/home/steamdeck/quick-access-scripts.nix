{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.quick-access-scripts ];

  self.quick-access-scripts = {
    "10-smt" = ''
      f=/sys/devices/system/cpu/smt/control
      case ''${1:-} in
        "Enable SMT")
          ${config.self.sudo-passwordless.path} sh -c "echo on > $f" ;;
        "Disable SMT")
          ${config.self.sudo-passwordless.path} sh -c "echo off > $f" ;;
        *)
          [ "$(cat "$f")" = on ] &&
          echo "Disable SMT" ||
          echo "Enable SMT" ;;
      esac
    '';

    "15-battery" = ''
      f=$(echo /sys/class/hwmon/*/max_battery_charge_level)
      limit=$(awk '/"ChargeLimit"/ {gsub(/"/, "", $2); print $2}' ~/.local/share/Steam/config/config.vdf); limit=''${limit:-80}
      case ''${1:-} in
        "Charge to 100%")
          ${config.self.sudo-passwordless.path} sh -c "echo 0 > $f" ;;
        "Limit charge to $limit%")
          ${config.self.sudo-passwordless.path} sh -c "echo $limit > $f" ;;
        *)
          [ "$(cat "$f")" = 0 ] &&
          echo "Limit charge to $limit%" ||
          echo "Charge to 100%" ;;
      esac
    '';

    "25-logs" = ''
      if [ $# = 0 ]; then
        echo "Show latest logs"
      else
        journalctl --no-pager --lines=100
      fi
    '';

    "39-restart-steam" = ''
      if [ $# = 0 ]; then
        echo "Restart Steam"
      else
        killall steam
      fi
    '';
  };
}
