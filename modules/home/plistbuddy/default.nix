{ config, lib, ... }:
{
  self.scripts.write.plistbuddy.text = lib.concatMapStrings (x: ''
    /usr/libexec/PlistBuddy -c ${lib.escapeShellArg x.command} ${lib.escapeShellArg x.file} || :
  '') config.self.plistbuddy;
}
