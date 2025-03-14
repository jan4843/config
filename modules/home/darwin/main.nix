args: {
  imports = with args.inputs.self.homeModules; [
    hammerspoon
    homebrew
    open-at-login
    plistbuddy
    tcc
    xcode-cli-tools
  ];
}
