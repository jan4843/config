args: {
  self.bash.profile = args.lib.concatLines (
    args.lib.attrsets.mapAttrsToList (name: body: ''
      alias -- ${args.lib.escapeShellArg name}=${args.lib.escapeShellArg body}
    '') args.config.self.bash.aliases
  );
}
