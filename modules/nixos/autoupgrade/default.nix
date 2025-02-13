{ inputs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "${inputs.self}";
  };
}
