args: {
  boot.postBootCommands = "ln -sfn ${args.inputs.self} /run/booted-config";
  systemd.tmpfiles.rules = [ "L+ /run/current-config - - - - ${args.inputs.self}" ];
}
