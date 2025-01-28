{
  self.scripts.install."00-xcode-cli-tools" = {
    path = [ "darwin" ];
    text = ''
      if ! [ -e /Library/Developer/CommandLineTools ]; then
        sudo touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        sudo softwareupdate --install "$(
          softwareupdate --list |
          awk -F 'Label: ' '/Label: Command Line Tools/{ print $2 }' |
          tail -1
        )"
      fi
    '';
  };
}
