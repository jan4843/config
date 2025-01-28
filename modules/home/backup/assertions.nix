{ config, ... }:
{
  assertions = [
    {
      assertion = config.self.backup.paths != [ ];
      message = "at least one self.backup.paths must be set";
    }
    {
      assertion = builtins.any (v: !builtins.isNull v) (builtins.attrValues config.self.backup.retention);
      message = "at least one self.backup.retention policy must be set";
    }
  ];
}
