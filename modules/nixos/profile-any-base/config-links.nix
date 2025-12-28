{ inputs, ... }:
{
  boot.postBootCommands = "ln -sfn ${inputs.self} /run/booted-config";
  systemd.tmpfiles.rules = [ "L+ /run/current-config - - - - ${inputs.self}" ];
}
