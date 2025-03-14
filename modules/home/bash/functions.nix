args: {
  self.bash.profile = args.lib.concatLines (
    args.lib.attrsets.mapAttrsToList (name: body: ''
      function ${name} {
      ${body}
      }
    '') args.config.self.bash.functions
  );
}
