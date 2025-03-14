args: {
  self.scripts.write.plistbuddy.text = args.lib.concatMapStrings (x: ''
    /usr/libexec/PlistBuddy -c ${args.lib.escapeShellArg x.command} ${args.lib.escapeShellArg x.file} || :
  '') args.config.self.plistbuddy;
}
